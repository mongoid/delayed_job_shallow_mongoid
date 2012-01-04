require 'rubygems'
require 'bundler/setup'

require 'mail'
require 'action_mailer'
require 'mongoid'
require 'delayed_job_shallow_mongoid'

Mongoid.configure do |config|
  name = "delayed_job_shallow_mongoid_test"
  config.master = Mongo::Connection.new.db(name)
  config.logger = Logger.new('/dev/null')
end

RSpec.configure do |config|
  config.before(:each) do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
  config.after(:all) do
    Mongoid.master.command({'dropDatabase' => 1})
  end
end