require 'rubygems'
require 'bundler'
require 'rack/test'

require 'simplecov'
SimpleCov.start

Dir['./spec/support/**/*.rb'].each &method(:require)


Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'unleashed_integration.rb')

Sinatra::Base.environment = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data("API_ID") do |interaction|
    sample_credentials["api_id"]
  end

  c.filter_sensitive_data("API_KEY") do |interaction|
    sample_credentials["api_key"]
  end
end

def app
  UnleashedIntegration
end