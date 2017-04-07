Mongoid.configure do |config|
  config.connect_to('delayed_job_shallow_mongoid_test')
end

RSpec.configure do |config|
  config.before(:all) do
    Mongoid.logger.level = Logger::INFO
    if Mongoid::Compatibility::Version.mongoid5? || Mongoid::Compatibility::Version.mongoid6?
      Mongo::Logger.logger.level = Logger::INFO
    end
  end
  config.before(:each) do
    Mongoid.purge!
    Mongoid::IdentityMap.clear if Delayed::ShallowMongoid.mongoid3?
  end
  config.after(:all) do
    if Mongoid::Compatibility::Version.mongoid3? || Mongoid::Compatibility::Version.mongoid4?
      Mongoid.default_session.drop
    else
      Mongoid::Clients.default.database.drop
    end
  end
end
