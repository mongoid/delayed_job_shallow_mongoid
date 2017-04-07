require 'spec_helper'

describe Delayed::PerformableMailer do
  it 'queues and delivers a delayed mail' do
    expect do
      TestMailer.delay.reticulate
    end.to change(Delayed::Job, :count).by(1)
    job = Delayed::Job.last
    expect(job.payload_object.class).to eq(Delayed::PerformableMailer)
    expect(job.payload_object.object).to eq(TestMailer)
    expect(job.payload_object.method_name).to eq(:reticulate)
    expect(job.payload_object.args).to eq([])
    if ActionMailer::VERSION::STRING >= '4.2.0'
      expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now).once
    else
      expect_any_instance_of(Mail::Message).to receive(:deliver).once
    end
    expect(Delayed::Worker.new.work_off).to eq([1, 0])
  end
  context 'with args' do
    before :each do
      @arg = TestModel.create!
    end
    it 'ignores deleted models when find raises Mongoid::Errors::DocumentNotFound' do
      expect do
        TestMailer.delay.reticulate(@arg)
      end.to change(Delayed::Job, :count).by(1)
      @arg.destroy
      if ActionMailer::VERSION::STRING >= '4.2.0'
        expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now).never
      else
        expect_any_instance_of(Mail::Message).to receive(:deliver).never
      end
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
    end
    it "ignores deleted models when find doesn't raise an error" do
      expect(TestModel).to receive(:find).with(@arg.id.to_s).and_return(nil)
      expect do
        TestMailer.delay.reticulate(@arg)
      end.to change(Delayed::Job, :count).by(1)
      if ActionMailer::VERSION::STRING >= '4.2.0'
        expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now).never
      else
        expect_any_instance_of(Mail::Message).to receive(:deliver).never
      end
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
    end
  end
end
