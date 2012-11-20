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
    Mail::Message.any_instance.should_receive(:deliver).once
    Delayed::Worker.new.work_off.should == [1, 0]
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
      Mail::Message.any_instance.should_not_receive(:deliver)
      Delayed::Worker.new.work_off.should == [1, 0]
    end
    it "ignores deleted models when find doesn't raise an error" do
      TestModel.should_receive(:find).with(@arg.id.to_s).and_return(nil)
      expect {
        TestMailer.delay.reticulate(@arg)
      }.to change(Delayed::Job, :count).by(1)
      Mail::Message.any_instance.should_not_receive(:deliver)
      Delayed::Worker.new.work_off.should == [1, 0]
    end
  end
end
