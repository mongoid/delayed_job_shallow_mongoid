require 'spec_helper'

describe Delayed::PerformableMailer do
  it "queues and delivers a delayed mail" do
    expect {
      TestMailer.delay.reticulate
    }.to change(Delayed::Job, :count).by(1)
    job = Delayed::Job.last
    expect(job.payload_object.class).to eq(Delayed::PerformableMailer)
    expect(job.payload_object.object).to eq(TestMailer)
    expect(job.payload_object.method_name).to eq(:reticulate)
    expect(job.payload_object.args).to eq([])
    expect_any_instance_of(Mail::Message).to receive(:deliver).once
    expect(Delayed::Worker.new.work_off).to eq([1, 0])
  end
  context "with args" do
    before :each do
      @arg = TestModel.create!
    end
    it "ignores deleted models when find raises Mongoid::Errors::DocumentNotFound" do
      expect {
        TestMailer.delay.reticulate(@arg)
      }.to change(Delayed::Job, :count).by(1)
      @arg.destroy
      expect_any_instance_of(Mail::Message).to receive(:deliver).never
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
    end
    it "ignores deleted models when find doesn't raise an error" do
      expect(TestModel).to receive(:find).with(@arg.id.to_s).and_return(nil)
      expect {
        TestMailer.delay.reticulate(@arg)
      }.to change(Delayed::Job, :count).by(1)
      expect_any_instance_of(Mail::Message).to receive(:deliver).never
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
    end
  end
end
