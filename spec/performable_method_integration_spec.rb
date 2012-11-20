require 'spec_helper'

describe Delayed::PerformableMethod do
  context "model" do
    before :each do
      @model = TestModel.create!
    end
    it "queues and runs a delayed job" do
      expect {
        @model.delay.reticulate!
      }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.payload_object.class).to eq(Delayed::PerformableMethod)
      expect(job.payload_object.object.class).to eq(Delayed::ShallowMongoid::DocumentStub)
      expect(job.payload_object.method_name).to eq(:reticulate!)
      expect(job.payload_object.args).to eq([])
      TestModel.any_instance.should_receive(:reticulate!).once
      Delayed::Worker.new.work_off.should == [1, 0]
    end
    context "without args" do
      it "ignores deleted models when find raises Mongoid::Errors::DocumentNotFound" do
        TestModel.any_instance.should_not_receive(:reticulate!)
        @model.delay.reticulate!
        @model.destroy
        Delayed::Worker.new.work_off.should == [1, 0]
      end
      it "ignores deleted models when find doesn't raise an error" do
        TestModel.any_instance.should_not_receive(:reticulate!)
        TestModel.should_receive(:find).with(@model.id.to_s).and_return(nil)
        @model.delay.reticulate!
        Delayed::Worker.new.work_off.should == [1, 0]
      end
    end
    context "with args" do
      before :each do
        @arg = TestModel.create!
      end
      it "ignores deleted models when find raises Mongoid::Errors::DocumentNotFound" do
        @model.delay.reticulate!(@arg)
        @arg.destroy
        TestModel.any_instance.should_not_receive(:reticulate!)
        Delayed::Worker.new.work_off.should == [1, 0]
      end
      it "ignores deleted models when find doesn't raise an error" do
        TestModel.any_instance.should_not_receive(:reticulate!)
        TestModel.should_receive(:find).with(@model.id.to_s).and_return(@model)
        TestModel.should_receive(:find).with(@arg.id.to_s).and_return(nil)
        @model.delay.reticulate!(@arg)
        Delayed::Worker.new.work_off.should == [1, 0]
      end
    end
  end
end
