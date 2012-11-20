require 'spec_helper'

describe ::Delayed::PerformableMethod do
  context "with an unsaved document" do
    it "should not transform an unsaved document" do
      @model = TestModel.new
      method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
      method.object.should_not be_a_kind_of(Delayed::ShallowMongoid::DocumentStub)
    end
  end

  context "with a saved document" do
    before(:each) do
      @model = TestModel.create #new(:_id => Moped::BSON::ObjectId.new)
    end

    context 'when saving job' do
      context 'when jobs are run immediately' do
        before { ::Delayed::Worker.delay_jobs = false }
        after { ::Delayed::Worker.delay_jobs = true }
        it "should not transform if there are pending changes and jobs are run immediately" do
          @model.title = "updated"
          method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
          method.object.should_not be_a_kind_of(Delayed::ShallowMongoid::DocumentStub)
        end
      end
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
          @child = ChildModel.new(:_id => Moped::BSON::ObjectId.new)
          @model.child_models.push @child
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
          @grandchild = GrandchildModel.new(:_id => Moped::BSON::ObjectId.new)
          @model.child_models.first.grandchild_models.push @grandchild
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
        error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, nil, [ @model.id ])
        TestModel.should_receive(:find).with(@model._id.to_s).and_raise(error)
        method.perform.should be_true
      end
      it "should do nothing if document find returned nil" do
        method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
        @model.destroy
        TestModel.should_receive(:find).with(@model._id.to_s).and_return(nil)
        method.perform.should be_true
      end
      it "should find embedded document" do
        child = ChildModel.new(:_id => Moped::BSON::ObjectId.new)
        @model.child_models.push child
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
        child = ChildModel.new(:_id => Moped::BSON::ObjectId.new)
        @model.child_models.push child
        method = ::Delayed::PerformableMethod.new(child, :to_s, [])
        method.display_name.should == "TestModel[#{@model._id}].child_models.find(\"#{child._id}\")#to_s"
      end
    end
  end
end
