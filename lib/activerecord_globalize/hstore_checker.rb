module ActiverecordGlobalize
  module HstoreChecker
    def self.native_hstore?
      @native_hstore ||= ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES.key?(:hstore)
    end
  end
end
