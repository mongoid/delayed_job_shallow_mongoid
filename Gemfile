# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'mongoid', ENV.fetch('MONGOID_VERSION', '~> 9.0')

rails_version = ENV.fetch('RAILS_VERSION', '~> 8.1')
gem 'actionmailer', rails_version
gem 'activemodel', rails_version
gem 'activesupport', rails_version

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1')
  gem 'danger', '~> 9.0'
  gem 'danger-changelog', '~> 0.10'
  gem 'danger-pr-comment', '~> 0.1.1'
end

gem 'rake', '~> 13.0'
gem 'rspec', '~> 3.13'
gem 'rubocop', '~> 1.75'
gem 'simplecov', '~> 0.22'
gem 'simplecov-lcov', '~> 0.8'
