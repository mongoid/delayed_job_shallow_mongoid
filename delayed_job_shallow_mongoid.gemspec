# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delayed/shallow_mongoid/version'

Gem::Specification.new do |s|
  s.name = 'delayed_job_shallow_mongoid'
  s.version = Delayed::ShallowMongoid::VERSION
  s.required_ruby_version = '>= 2.7'

  s.authors = ['Joey Aghion', 'Daniel Doubrovkine']
  s.description = 'When the object or arg to a delayed_job is a Mongoid document, store only a small stub of the object instead of the full serialization.'
  s.email = 'joey@aghion.com'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.files = Dir[
    '.document',
    'CHANGELOG.md',
    'Gemfile',
    'LICENSE.txt',
    'README.md',
    'Rakefile',
    'delayed_job_shallow_mongoid.gemspec',
    'lib/**/*'
  ]
  s.homepage = 'https://github.com/mongoid/delayed_job_shallow_mongoid'
  s.metadata = {
    'source_code_uri' => s.homepage,
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'rubygems_mfa_required' => 'true'
  }
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.summary = 'More efficient Mongoid document serialization for delayed_job.'

  s.add_dependency('activesupport', ['>= 3.2'])
  s.add_dependency('delayed_job', ['>= 3.0'])
  s.add_dependency('delayed_job_mongoid', ['>= 2.0'])
  s.add_dependency('mongoid', ['>= 3.0'])
end
