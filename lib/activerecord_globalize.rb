require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'
require 'activerecord_globalize/version'
require 'activerecord_globalize/hstore_checker'
require 'activerecord_globalize/translates'
require 'activerecord-postgres-hstore' unless ActiverecordGlobalize::HstoreChecker::native_hstore?

module ActiverecordGlobalize
end
