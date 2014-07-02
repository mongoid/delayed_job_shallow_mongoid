require 'delayed_job'

ActionMailer::Base.send(:extend, Delayed::DelayMail)
