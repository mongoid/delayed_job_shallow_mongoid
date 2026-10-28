# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'mongoid', ENV.fetch('MONGOID_VERSION', '~> 9.0')

rails_version = ENV.fetch('RAILS_VERSION', '~> 8.1')
gem 'actionmailer', rails_version
gem 'activemodel', rails_version
gem 'activesupport', rails_version

gem 'rake', '~> 13.0'
gem 'rspec', '~> 3.13'
gem 'rubocop', '~> 1.75'
gem 'simplecov', '~> 0.22'
gem 'simplecov-lcov', '~> 0.8'
