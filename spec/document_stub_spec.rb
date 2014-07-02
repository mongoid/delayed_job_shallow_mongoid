require 'spec_helper'

describe Delayed::ShallowMongoid::DocumentStub do
  it 'has a klass' do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111)
    expect(@shallow.klass).to eq(TestModel)
  end
  it 'has an id' do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111)
    expect(@shallow.id).to eq(111)
  end
  it 'has an optional selector' do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111)
    expect(@shallow.selector).to be_nil
  end
  it 'can have an actual selector' do
    @shallow = Delayed::ShallowMongoid::DocumentStub.new(TestModel, 111, [:a, :b])
    expect(@shallow.selector).to eq([:a, :b])
  end
end
