module ActiverecordGlobalize
  module Translates # :nodoc:
    def self.included(base)
      base.extend ClassMethods
      # holds all translated fields
      base.class_attribute :translated_attrs
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      ##
      # set value to a specific/current locale and fire ActiveRecord attribute_will_change!
      # if the current locale equals the default locale update value of original field
      #
      # +attr_name+ field name
      # +value+ locale value
      # +locale+ desired locale
      def write_translation(attr_name, value, locale = I18n.locale)
        translation_store = translated_attr_name(attr_name)
        translations = send(translation_store) || {}
        send("#{translation_store}_will_change!") unless translations[locale.to_s] == value
        translations[locale.to_s] = value
        send("#{translation_store}=", translations)
        self[attr_name] = value if I18n.default_locale == I18n.locale
        value
      end

      ##
      # get translations hstore of the field then
      # if the current locale in translations return it's value
      # if not return the default locale's value
      # if current/default locale not found return actual field value
      #
      # +attr_name+ field name
      # +locale+ desired locale
      def read_translation(attr_name, locale = I18n.locale)
        translations = send(translated_attr_name(attr_name)) || {}
        return translations[locale] if translations.key?(locale)
        return translations[I18n.default_locale] if translations.key?(I18n.default_locale)
        self[attr_name]
      end

      # return translated field name of a field
      def translated_attr_name(attr_name)
        "#{attr_name}_translations"
      end

      # Overrides to_json to exclude translated_attrs
      def as_json(*)
        attributes.delete_if { |k, _v| translated_attrs.map { |f| translated_attr_name(f) }.include?(k) }
      end

      # activerecord update attributes in specific locale
      def update_with_locale!(locale, *attrs)
        I18n.with_locale locale do
          update!(*attrs)
        end
      end
    end

    # Patches ActiveRecord models
    module ClassMethods
      # Overrides ActiveRecord getters and setters to consider I18n locales
      #
      # +attrs+ translated fields names
      def translates(*attrs)
        raise(ArgumentError, 'must have at least one record to localize') if attrs.empty?

        self.translated_attrs = attrs
        attrs.each do |attr_name|
          define_method "#{attr_name}=" do |value|
            write_translation(attr_name, value)
          end

          define_method attr_name do
            read_translation(attr_name)
          end

          define_method "#{attr_name}_translations" do
            self["#{attr_name}_translations"].try(:with_indifferent_access)
          end
        end
      end
    end
  end

  # include Translates on ActiveRecord models
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.send(:include, Translates)
  end
end
