source 'https://rubygems.org'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'endpoint_base', github: 'spree/endpoint_base'
gem 'httparty'
gem 'simplecov'
gem 'nokogiri'

group :development do
  gem 'pry'
end

group :development, :test do
  gem 'pry-byebug'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end
