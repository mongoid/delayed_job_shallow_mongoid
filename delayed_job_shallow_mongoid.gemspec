# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delayed/shallow_mongoid/version'

Gem::Specification.new do |s|
  s.name = 'delayed_job_shallow_mongoid'
  s.version = Delayed::ShallowMongoid::VERSION

  s.authors = ['Joey Aghion', 'Daniel Doubrovkine']
  s.description = 'When the object or arg to a delayed_job is a Mongoid document, store only a small stub of the object instead of the full serialization.'
  s.email = 'joey@aghion.com'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.files = Dir[
    '.document',
    '.travis.yml',
    'CHANGELOG.md',
    'Gemfile',
    'LICENSE.txt',
    'README.md',
    'Rakefile',
    'delayed_job_shallow_mongoid.gemspec',
    'lib/**/*'
  ]
  s.homepage = 'http://github.com/joeyAghion/delayed_job_shallow_mongoid'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.summary = 'More efficient Mongoid document serialization for delayed_job.'

  s.specification_version = 3
  s.add_runtime_dependency('delayed_job', ['>= 3.0'])
  s.add_runtime_dependency('delayed_job_mongoid', ['>= 2.0'])
  s.add_runtime_dependency('mongoid', ['>= 3.0'])
  s.add_runtime_dependency('activesupport', ['>= 3.2'])
  s.add_development_dependency('actionmailer', ['>= 0'])
  s.add_development_dependency('shoulda', ['>= 0'])
  s.add_development_dependency('rake', ['~> 10.0'])
  s.add_development_dependency('rspec', ['>= 3.0'])
  s.add_development_dependency('rubocop', ['0.24.0'])
end
