require 'spec_helper'

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
