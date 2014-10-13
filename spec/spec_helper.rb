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

def app
  UnleashedIntegration
end