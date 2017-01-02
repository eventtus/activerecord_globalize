require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'pg'
require 'rspec'
require 'database_loader'
require 'database_cleaner'
require 'activerecord_globalize'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run focus: true
  config.order = :random

  config.before(:suite) do
    # Cleanup the database
    DatabaseLoader.prepare_database
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    I18n.available_locales = ['en', 'en-US', 'fr']
    I18n.config.enforce_available_locales = true
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

class Post < ActiveRecord::Base
  translates :title
end
