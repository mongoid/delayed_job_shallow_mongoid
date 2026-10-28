# frozen_string_literal: true

Mongoid.configure do |config|
  config.load_configuration(
    clients: {
      default: { uri: ENV.fetch('MONGODB_URI', 'mongodb://127.0.0.1:27017/delayed_job_shallow_mongoid_test') }
    }
  )
end

RSpec.configure do |config|
  config.before(:all) do
    Mongoid.logger.level = Logger::INFO
    Mongo::Logger.logger.level = Logger::WARN
  end
  config.before(:each) do
    Mongoid.purge!
  end
  config.after(:all) do
    Mongoid::Clients.default.database.drop
  end
end
