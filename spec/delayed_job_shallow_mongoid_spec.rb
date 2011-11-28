require 'spec_helper'

class TestModel
  include ::Mongoid::Document
end

describe Delayed::ShallowMongoidDocument do
  before(:each) do
    @shallow = Delayed::ShallowMongoidDocument.new(TestModel, 111)
  end
  it "should have a klass" do
    @shallow.klass.should == TestModel
  end
  it "should have an id" do
    @shallow.id.should == 111
  end
end

describe ::Delayed::PerformableMethod do
  before(:each) do
    @model = TestModel.new
    @model_id = ::BSON::ObjectId.new
    @model.stub(:_id) { @model_id }
  end

  context 'when saving job' do
    it "should transform object into shallow version" do
      method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
      method.object.should be_a_kind_of(Delayed::ShallowMongoidDocument)
      method.object.id.should == @model_id.to_s
    end
    it "should transform arg into shallow version" do
      method = ::Delayed::PerformableMethod.new('test', :lines, [@model])
      method.args.first.should be_a_kind_of(Delayed::ShallowMongoidDocument)
      method.args.first.id.should == @model_id.to_s
    end
  end

  context 'when running job' do
    before(:each) do
      @method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
    end
    it "should look up document" do
      TestModel.should_receive(:find).with(@model_id.to_s).and_return(@model)
      @method.perform
    end
    it "should do nothing if document not found" do
      error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, @model_id)
      TestModel.should_receive(:find).with(@model_id.to_s).and_raise(error)
      @method.perform.should be_true
    end
  end
end

