require 'rubygems'
require 'bundler/setup'

require 'mail'
require 'action_mailer'
require 'mongoid'

[ "support/*.rb", "config/*.rb" ].each do |path|
  Dir["#{File.dirname(__FILE__)}/#{path}"].each do |file|
    require file
  end
end

require 'delayed_job_shallow_mongoid'

