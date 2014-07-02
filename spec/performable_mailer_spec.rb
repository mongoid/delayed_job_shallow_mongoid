require 'spec_helper'

describe ::Delayed::PerformableMailer do
  context 'successful mailer' do
    before do
      @model = TestModel.create
      @email = double('email', deliver: true)
      @mailer_class = double('MailerClass', signup: @email)
      @mailer = ::Delayed::PerformableMailer.new(@mailer_class, :signup, [@model])
    end
    it 'calls the method and #deliver on the mailer' do
      expect(TestModel).to receive(:find).with(@model._id.to_s).and_return(@model)
      expect(@mailer_class).to receive(:signup).with(@model)
      expect(@email).to receive(:deliver)
      @mailer.perform
    end
    it 'does nothing if an argument document is not found' do
      error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, nil, [@model._id])
      expect(TestModel).to receive(:find).with(@model._id.to_s).and_raise(error)
      expect(@mailer.perform).to eq(true)
    end
    it 'does nothing if an argument document is nil' do
      expect(TestModel).to receive(:find).with(@model._id.to_s).and_return(nil)
      expect_any_instance_of(Mail::Message).to receive(:deliver).never
      expect(@mailer.perform).to eq(true)
    end
  end
  context 'failing mailer from bad record' do
    before do
      @model = TestModel.create
      error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, nil, [@model._id])
      @email = double('email')
      expect(@email).to receive(:deliver).and_raise(error)
      @mailer_class = double('MailerClass', signup: @email)
      @mailer = ::Delayed::PerformableMailer.new(@mailer_class, :signup, [@model])
    end
    it 'fails if an exception comes up' do
      expect(TestModel).to receive(:find).with(@model._id.to_s).and_return(@model)
      expect { @mailer.perform }.to raise_error(::Mongoid::Errors::DocumentNotFound)
    end
  end
end
