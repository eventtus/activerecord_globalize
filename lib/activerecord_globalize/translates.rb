module ActiverecordGlobalize
  module Translates
    def self.included(base)
      base.extend ClassMethods
      base.class_attribute :translated_attrs
    end

    module ClassMethods
      def translates(*attrs)
        raise(ArgumentError, 'must have at least one record to localize') if attrs.empty?

        self.translated_attrs = attrs
        attrs.each do |attr_name|
          define_method "#{attr_name}=" do |value|
          end

          define_method attr_name do
          end

          define_method "#{attr_name}_translations" do
          end
        end
      end
    end
  end
  
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.send(:include, Translates)
  end
end
