ENV['RAILS_ENV'] ||= 'test'
require 'rubygems'
require 'rails/all'
require 'bundler/setup'
require 'fast_versioning'
require 'paper_trail'
require File.expand_path('app/models/fast_versioning/fast_version.rb')

path = File.expand_path('../support/**/*.rb', __FILE__)
Dir.glob(path) { |file| require file }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.mock_with :rspec
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
