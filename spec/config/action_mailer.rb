# frozen_string_literal: true

require 'delayed_job'

ActionMailer::Base.extend Delayed::DelayMail
ActionMailer::Base.delivery_method = :test

RSpec.configure do |config|
  config.before { ActionMailer::Base.deliveries.clear }
end
