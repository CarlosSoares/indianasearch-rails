require 'bundler/setup'
require 'simplecov'
Bundler.setup
SimpleCov.start

require 'byebug'
require 'active_record'
require 'rest-client'
require 'faker'
require 'indianasearch' # and any other gems you need

Dir['./spec/app/**/*.rb'].each { |f| require f }

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
# Create default table
ActiveRecord::Base.connection.create_table :companies do |t|
  t.string :name
end

RSpec.configure do |config|
  # some (optional) config here
end
