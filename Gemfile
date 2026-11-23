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
  gem 'danger-pr-comment', '~> 0.3'
end

gem 'rake', '~> 13.0'
gem 'rspec', '~> 3.13'
gem 'simplecov', '~> 0.22'
gem 'simplecov-lcov', '~> 0.8'

group :development, :test do
  if RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3')
    gem 'rubocop', '~> 1.92'
    gem 'rubocop-md', '~> 3.0', require: false
    gem 'rubocop-prose', '~> 0.2', require: false
    gem 'rubocop-rake', '~> 0.7', require: false
    gem 'rubocop-spellcheck', '~> 0.2', require: false
    gem 'rubocop-yaml', '~> 0.1.0', require: false
  end
end
