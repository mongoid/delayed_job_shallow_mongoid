require 'spec_helper'

class GrandchildModel
  include ::Mongoid::Document
  embedded_in :child_model, :inverse_of => :grandchild_models
end
class ChildModel
  include ::Mongoid::Document
  embedded_in :test_model, :inverse_of => :child_models
  embeds_many :grandchild_models
end
class TestModel
  include ::Mongoid::Document
  embeds_many :child_models
end

describe Delayed::ShallowMongoid::DocumentStub do
  it "should have a klass" do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111)
    @shallow.klass.should == TestModel
  end
  it "should have an id" do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111)
    @shallow.id.should == 111
  end
  it "should have an optional selector" do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111)
    @shallow.selector.should == nil
  end
  it "can have an actual selector" do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111, [:a, :b])
    @shallow.selector.should == [:a, :b]
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
    context "with an embedded document" do
      before(:each) do
        @child = ChildModel.new(:_id => ::BSON::ObjectId.new)
        @model.child_models << @child
      end
      after(:each) do
        @method.object.should be_a_kind_of(Delayed::ShallowMongoid::DocumentStub)
        @method.object.id.should == @model.id.to_s
        @method.object.klass.should == @model.class
      end
      it "should store the selector" do
        @method = ::Delayed::PerformableMethod.new(@child, :to_s, [])
        @method.object.selector.should == ['child_models', ['find', @child._id.to_s]]
      end
      it "should store the deeply nested selector" do
        @grandchild = GrandchildModel.new(:_id => ::BSON::ObjectId.new)
        @model.child_models.first.grandchild_models << @grandchild
        @method = ::Delayed::PerformableMethod.new(@grandchild, :to_s, [])
        @method.object.selector.should == ['child_models', ['find', @child._id.to_s], 'grandchild_models', ['find', @grandchild._id.to_s]]
      end
      
    end
  end

  context 'when running job' do
    it "should look up document" do
      method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
      TestModel.should_receive(:find).with(@model._id.to_s).and_return(@model)
      method.perform
    end
    it "should do nothing if document not found" do
      method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
      error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, @model._id)
      TestModel.should_receive(:find).with(@model._id.to_s).and_raise(error)
      method.perform.should be_true
    end
    it "should find embedded document" do
      child = ChildModel.new(:_id => ::BSON::ObjectId.new)
      @model.child_models << child
      method = ::Delayed::PerformableMethod.new(child, :to_s, [])
      TestModel.should_receive(:find).with(@model._id.to_s).and_return(@model)
      method.perform
    end
  end
  
  context "display_name" do
    it "should return underlying class when a stub is being used" do
      method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
      method.display_name.should == "TestModel[#{@model._id}]#to_s"
    end
    it "should return usual name when no stub is involved" do
      method = ::Delayed::PerformableMethod.new(:test, :to_s, [])
      method.display_name.should == "Symbol#to_s"
    end
    it "should include selector when document is embedded" do
      child = ChildModel.new(:_id => ::BSON::ObjectId.new)
      @model.child_models << child
      method = ::Delayed::PerformableMethod.new(child, :to_s, [])
      method.display_name.should == "TestModel[#{@model._id}].child_models.find(\"#{child._id}\")#to_s"
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
