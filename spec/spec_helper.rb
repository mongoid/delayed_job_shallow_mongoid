# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.single_report_path = 'coverage/lcov.info'
end
SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::LcovFormatter]
SimpleCov.start do
  enable_coverage :branch
  minimum_coverage line: 90, branch: 80
  add_filter '/spec/'
  track_files 'lib/**/*.rb'
end

require 'logger'
require 'mail'
require 'action_mailer'
require 'mongoid'

['support/*.rb', 'config/*.rb'].each do |path|
  Dir["#{File.dirname(__FILE__)}/#{path}"].sort.each do |file|
    require file
  end
end

require 'delayed_job_shallow_mongoid'
