# frozen_string_literal: true

class TestMailer < ActionMailer::Base
  default from: 'William Bell <bill@example.com>'

  def reticulate(spline = nil)
    mail(
      from: 'bill@example.com',
      to: 'bob@example.com',
      subject: 'reticulated spline',
      spline: spline ? 'yes' : 'no'
    ) do |format|
      format.text { render plain: 'A spline has been reticulated.' }
    end
  end
end
