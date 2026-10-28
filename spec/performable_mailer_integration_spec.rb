# frozen_string_literal: true

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
    expect(Delayed::Worker.new.work_off).to eq([1, 0])
    expect(ActionMailer::Base.deliveries.map(&:subject)).to eq(['reticulated spline'])
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
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
      expect(ActionMailer::Base.deliveries).to be_empty
    end
    it "ignores deleted models when find doesn't raise an error" do
      expect(TestModel).to receive(:find).with(@arg.id.to_s).and_return(nil)
      expect do
        TestMailer.delay.reticulate(@arg)
      end.to change(Delayed::Job, :count).by(1)
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
