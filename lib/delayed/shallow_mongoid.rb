module Delayed
  module ShallowMongoid

    module Errors
      class DocumentNotFound < StandardError
      end
    end

    def self.dump(arg)
      return arg unless arg.is_a?(::Mongoid::Document) && arg.persisted?
      return arg if arg._updates.any? && !Delayed::Worker.delay_jobs
      if arg.embedded?
        Delayed::ShallowMongoid::DocumentStub.new(arg._root.class, arg._root._id.to_s, selector_from(arg))
      else
        Delayed::ShallowMongoid::DocumentStub.new(arg.class, arg._id.to_s)
      end
    end

    def self.load(arg)
      return arg unless arg.is_a?(Delayed::ShallowMongoid::DocumentStub)
      begin
        result = arg.klass.find(arg.id)
        raise Delayed::ShallowMongoid::Errors::DocumentNotFound unless result
      rescue Mongoid::Errors::DocumentNotFound
        raise Delayed::ShallowMongoid::Errors::DocumentNotFound
      end
      (arg.selector || []).each do |message|
        result = result.send(*message)
      end
      raise Delayed::ShallowMongoid::Errors::DocumentNotFound unless result
      result
    end

    # The chain of relations allowing us to locate an embedded document.
    # E.g., ['images', ['find', '4eef..678'], 'width']
    def self.selector_from(doc)
      [].tap do |selector|
        while doc._parent do
          selector.unshift ['find', doc._id.to_s] if Delayed::ShallowMongoid.metadata(doc).macro == :embeds_many
          selector.unshift Delayed::ShallowMongoid.metadata(doc).key
          doc = doc._parent
        end
      end
    end
  end
end
