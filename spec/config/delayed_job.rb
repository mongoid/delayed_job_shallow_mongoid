require 'delayed_job'
require 'delayed_job_mongoid'

Delayed::Worker.delay_jobs = true
