require 'spec_helper'

describe ::Delayed::PerformableMailer do
  context "successful mailer" do
    before do
      @model = TestModel.create
      @email = mock('email', :deliver => true)
      @mailer_class = mock('MailerClass', :signup => @email)
      @mailer = ::Delayed::PerformableMailer.new(@mailer_class, :signup, [@model])
    end
    it "calls the method and #deliver on the mailer" do
      TestModel.should_receive(:find).with(@model._id.to_s).and_return(@model)
      @mailer_class.should_receive(:signup).with(@model)
      @email.should_receive(:deliver)
      @mailer.perform
    end
    it "does nothing if an argument document is not found" do
      error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, nil, [ @model._id ])
      TestModel.should_receive(:find).with(@model._id.to_s).and_raise(error)
      @mailer.perform.should be_true
    end
    it "does nothing if an argument document is nil" do
      error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, nil, [ @model._id ])
      TestModel.should_receive(:find).with(@model._id.to_s).and_return(nil)
      Mail::Message.any_instance.should_not_receive(:deliver)
      @mailer.perform.should be_true
    end
  end
  context "failing mailer from bad record" do
    before do
      @model = TestModel.create
      error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, nil, [ @model._id ])
      @email = mock('email')
      @email.stub(:deliver).and_raise(error)
      @mailer_class = mock('MailerClass', :signup => @email)
      @mailer = ::Delayed::PerformableMailer.new(@mailer_class, :signup, [@model])
    end
    it "fails if an exception comes up" do
      TestModel.stub(:find).with(@model._id.to_s).and_return(@model)
      -> {
        @mailer.perform
      }.should raise_error(::Mongoid::Errors::DocumentNotFound)
    end
  end
end
