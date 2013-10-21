# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delayed/shallow_mongoid/version'

Gem::Specification.new do |s|
  s.name = "delayed_job_shallow_mongoid"
  s.version = Delayed::ShallowMongoid::VERSION

  s.authors = ["Joey Aghion", "Daniel Doubrovkine"]
  s.description = "When the object or arg to a delayed_job is a Mongoid document, store only a small stub of the object instead of the full serialization."
  s.email = "joey@aghion.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".travis.yml",
    "CHANGELOG.md",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "delayed_job_shallow_mongoid.gemspec",
    "lib/delayed/shallow_mongoid.rb",
    "lib/delayed/shallow_mongoid/document_stub.rb",
    "lib/delayed/shallow_mongoid/performable_mailer.rb",
    "lib/delayed/shallow_mongoid/performable_method.rb",
    "lib/delayed/shallow_mongoid/version.rb",
    "lib/delayed_job_shallow_mongoid.rb"
  ]
  s.homepage = "http://github.com/joeyAghion/delayed_job_shallow_mongoid"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = "More efficient Mongoid document serialization for delayed_job."

  s.specification_version = 3
  s.add_runtime_dependency(%q<delayed_job>, [">= 3.0"])
  s.add_runtime_dependency(%q<delayed_job_mongoid>, [">= 2.0"])
  s.add_runtime_dependency(%q<mongoid>, [">= 3.0"])
  s.add_development_dependency(%q<actionmailer>, [">= 0"])
  s.add_development_dependency(%q<shoulda>, [">= 0"])
  s.add_development_dependency(%q<rake>, ["~> 10.0"])
  s.add_development_dependency(%q<rspec>, [">= 0"])
  s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
end

