# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "delayed_job_shallow_mongoid"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joey Aghion"]
  s.date = "2011-11-29"
  s.description = "When the object or arg to a delayed_job is a Mongoid document, store only a small stub of the object instead of the full serialization."
  s.email = "joey@aghion.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "delayed_job_shallow_mongoid.gemspec",
    "lib/delayed/performable_mailer.rb",
    "lib/delayed/performable_method.rb",
    "lib/delayed/shallow_mongoid.rb",
    "lib/delayed/shallow_mongoid/document_stub.rb",
    "lib/delayed_job_shallow_mongoid.rb",
    "spec/delayed_job_shallow_mongoid_spec.rb",
    "spec/spec_helper.rb",
    "test/helper.rb",
    "test/test_delayed_job_shallow_mongoid.rb"
  ]
  s.homepage = "http://github.com/jaghion/delayed_job_shallow_mongoid"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "More efficient Mongoid document serialization for delayed_job."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionmailer>, [">= 0"])
      s.add_runtime_dependency(%q<delayed_job_mongoid>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
    else
      s.add_dependency(%q<actionmailer>, [">= 0"])
      s.add_dependency(%q<delayed_job_mongoid>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<ruby-debug19>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionmailer>, [">= 0"])
    s.add_dependency(%q<delayed_job_mongoid>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<ruby-debug19>, [">= 0"])
  end
end

