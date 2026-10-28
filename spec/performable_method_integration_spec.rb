# frozen_string_literal: true

require 'spec_helper'

describe Delayed::PerformableMethod do
  context 'model' do
    before :each do
      @model = TestModel.create!
    end
    it 'queues and runs a delayed job' do
      expect do
        @model.delay.reticulate!
      end.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.payload_object.class).to eq(Delayed::PerformableMethod)
      expect(job.payload_object.object.class).to eq(Delayed::ShallowMongoid::DocumentStub)
      expect(job.payload_object.method_name).to eq(:reticulate!)
      expect(job.payload_object.args).to eq([])
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
      expect(@model.reload.reticulated).to be true
    end

    it 'ignores an embedded document removed before the job runs' do
      child = @model.child_models.create!
      child.delay.to_s
      child.destroy

      expect(Delayed::Worker.new.work_off).to eq([1, 0])
      expect(Delayed::Job.count).to eq(0)
    end

    it 'ignores a nested document whose parent was removed before the job runs' do
      child = @model.child_models.create!
      grandchild = child.grandchild_models.create!
      grandchild.delay.to_s
      child.destroy

      expect(Delayed::Worker.new.work_off).to eq([1, 0])
      expect(Delayed::Job.count).to eq(0)
    end

    it 'ignores a missing embedded parent when lookups return nil' do
      allow(Mongoid).to receive(:raise_not_found_error).and_return(false)
      child = @model.child_models.create!
      grandchild = child.grandchild_models.create!
      grandchild.delay.to_s
      child.destroy

      expect(Delayed::Worker.new.work_off).to eq([1, 0])
      expect(Delayed::Job.count).to eq(0)
    end
    context 'without args' do
      it 'ignores deleted models when find raises Mongoid::Errors::DocumentNotFound' do
        expect_any_instance_of(TestModel).to receive(:reticulate!).never
        @model.delay.reticulate!
        @model.destroy
        expect(Delayed::Worker.new.work_off).to eq([1, 0])
      end
      it "ignores deleted models when find doesn't raise an error" do
        expect_any_instance_of(TestModel).to receive(:reticulate!).never
        expect(TestModel).to receive(:find).with(@model.id.to_s).and_return(nil)
        @model.delay.reticulate!
        expect(Delayed::Worker.new.work_off).to eq([1, 0])
      end
    end
    context 'with args' do
      before :each do
        @arg = TestModel.create!
      end
      it 'ignores deleted models when find raises Mongoid::Errors::DocumentNotFound' do
        @model.delay.reticulate!(@arg)
        @arg.destroy
        expect_any_instance_of(TestModel).to receive(:reticulate!).never
        expect(Delayed::Worker.new.work_off).to eq([1, 0])
      end
      it "ignores deleted models when find doesn't raise an error" do
        expect_any_instance_of(TestModel).to receive(:reticulate!).never
        expect(TestModel).to receive(:find).with(@model.id.to_s).and_return(@model)
        expect(TestModel).to receive(:find).with(@arg.id.to_s).and_return(nil)
        @model.delay.reticulate!(@arg)
        expect(Delayed::Worker.new.work_off).to eq([1, 0])
      end
    end
  end
end
