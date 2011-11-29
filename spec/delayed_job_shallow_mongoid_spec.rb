require 'spec_helper'

class TestModel
  include ::Mongoid::Document
end

describe Delayed::ShallowMongoid::DocumentStub do
  before(:each) do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111)
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
    @model = TestModel.new(:_id => ::BSON::ObjectId.new)
  end

  context 'when saving job' do
    it "should transform object into shallow version" do
      method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
      method.object.should be_a_kind_of(Delayed::ShallowMongoid::DocumentStub)
      method.object.id.should == @model._id.to_s
    end
    it "should transform arg into shallow version" do
      method = ::Delayed::PerformableMethod.new('test', :lines, [@model])
      method.args.first.should be_a_kind_of(Delayed::ShallowMongoid::DocumentStub)
      method.args.first.id.should == @model._id.to_s
    end
  end

  context 'when running job' do
    before(:each) do
      @method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
    end
    it "should look up document" do
      TestModel.should_receive(:find).with(@model._id.to_s).and_return(@model)
      @method.perform
    end
    it "should do nothing if document not found" do
      error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, @model._id)
      TestModel.should_receive(:find).with(@model._id.to_s).and_raise(error)
      @method.perform.should be_true
    end
  end
end

describe ::Delayed::PerformableMailer do
  before do
    @model = TestModel.new(:_id => ::BSON::ObjectId.new)
    @email = mock('email', :deliver => true)
    @mailer_class = mock('MailerClass', :signup => @email)
    @mailer = ::Delayed::PerformableMailer.new(@mailer_class, :signup, [@model])
  end
  it "should call the method and #deliver on the mailer" do
    TestModel.should_receive(:find).with(@model._id.to_s).and_return(@model)
    @mailer_class.should_receive(:signup).with(@model)
    @email.should_receive(:deliver)
    @mailer.perform
  end
end
