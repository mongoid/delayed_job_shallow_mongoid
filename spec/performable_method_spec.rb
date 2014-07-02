require 'spec_helper'

describe ::Delayed::PerformableMethod do
  context 'with an unsaved document' do
    it 'does not transform an unsaved document' do
      @model = TestModel.new
      method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
      expect(method.object).to_not be_kind_of(Delayed::ShallowMongoid::DocumentStub)
    end
  end

  context 'with a saved document' do
    before(:each) do
      @model = TestModel.create!
    end

    context 'when saving job' do
      context 'when jobs are run immediately' do
        before { ::Delayed::Worker.delay_jobs = false }
        after { ::Delayed::Worker.delay_jobs = true }
        it 'does not transform if there are pending changes and jobs are run immediately' do
          @model.title = 'updated'
          method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
          expect(method.object).to_not be_kind_of(Delayed::ShallowMongoid::DocumentStub)
        end
      end
      it 'transforms object into shallow version' do
        method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
        expect(method.object).to be_kind_of(Delayed::ShallowMongoid::DocumentStub)
        expect(method.object.id).to eq(@model._id.to_s)
      end
      it 'transforms arg into shallow version' do
        method = ::Delayed::PerformableMethod.new('test', :lines, [@model])
        expect(method.args.first).to be_kind_of(Delayed::ShallowMongoid::DocumentStub)
        expect(method.args.first.id).to eq(@model._id.to_s)
      end
      context 'with an embedded document' do
        before(:each) do
          @child = ChildModel.new
          @model.child_models.push @child
        end
        after(:each) do
          expect(@method.object).to be_kind_of(Delayed::ShallowMongoid::DocumentStub)
          expect(@method.object.id).to eq(@model.id.to_s)
          expect(@method.object.klass).to eq(@model.class)
        end
        it 'stores the selector' do
          @method = ::Delayed::PerformableMethod.new(@child, :to_s, [])
          expect(@method.object.selector).to eq(['child_models', ['find', @child._id.to_s]])
        end
        it 'stores the deeply nested selector' do
          @grandchild = GrandchildModel.new
          @model.child_models.first.grandchild_models.push @grandchild
          @method = ::Delayed::PerformableMethod.new(@grandchild, :to_s, [])
          expect(@method.object.selector).to eq(['child_models', ['find', @child._id.to_s], 'grandchild_models', ['find', @grandchild._id.to_s]])
        end
      end
    end

    context 'when running job' do
      it 'looks up document' do
        method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
        expect(TestModel).to receive(:find).with(@model._id.to_s).and_return(@model)
        method.perform
      end
      it 'does nothing if document not found' do
        method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
        error = ::Mongoid::Errors::DocumentNotFound.new(TestModel, nil, [@model.id])
        expect(TestModel).to receive(:find).with(@model._id.to_s).and_raise(error)
        expect(method.perform).to eq(true)
      end
      it 'does nothing if document find returned nil' do
        method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
        @model.destroy
        expect(TestModel).to receive(:find).with(@model._id.to_s).and_return(nil)
        expect(method.perform).to eq(true)
      end
      it 'finds embedded document' do
        child = ChildModel.new
        @model.child_models.push child
        method = ::Delayed::PerformableMethod.new(child, :to_s, [])
        expect(TestModel).to receive(:find).with(@model._id.to_s).and_return(@model)
        method.perform
      end
    end

    context 'display_name' do
      it 'returns underlying class when a stub is being used' do
        method = ::Delayed::PerformableMethod.new(@model, :to_s, [])
        expect(method.display_name).to eq("TestModel[#{@model._id}]#to_s")
      end
      it 'returns usual name when no stub is involved' do
        method = ::Delayed::PerformableMethod.new(:test, :to_s, [])
        expect(method.display_name).to eq('Symbol#to_s')
      end
      it 'includes selector when document is embedded' do
        child = ChildModel.new
        @model.child_models.push child
        method = ::Delayed::PerformableMethod.new(child, :to_s, [])
        expect(method.display_name).to eq("TestModel[#{@model._id}].child_models.find(\"#{child._id}\")#to_s")
      end
    end
  end
end
