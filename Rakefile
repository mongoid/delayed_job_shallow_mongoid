# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'rspec/core/rake_task'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "delayed_job_shallow_mongoid"
  gem.homepage = "http://github.com/joeyAghion/delayed_job_shallow_mongoid"
  gem.license = "MIT"
  gem.summary = %Q{More efficient Mongoid document serialization for delayed_job.}
  gem.description = %Q{When the object or arg to a delayed_job is a Mongoid document, store only a small stub of the object instead of the full serialization.}
  gem.email = "joey@aghion.com"
  gem.authors = ["Joey Aghion"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

desc "Run all tests"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "delayed_job_shallow_mongoid #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
