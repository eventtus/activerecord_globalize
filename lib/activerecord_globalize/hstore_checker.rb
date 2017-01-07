module ActiverecordGlobalize
  module HstoreChecker # :nodoc:
    ##
    # Check if database is supporting hstore data type by default
    def self.native_hstore?
      @native_hstore ||= ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES.key?(:hstore)
    end
  end
end
