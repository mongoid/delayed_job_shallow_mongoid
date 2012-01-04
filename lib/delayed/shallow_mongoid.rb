module Delayed
  module ShallowMongoid
    def self.dump(arg)
      return arg unless arg.is_a?(::Mongoid::Document) && arg.persisted?
      if arg.embedded?
        ShallowMongoid::DocumentStub.new(arg._root.class, arg._root._id.to_s, selector_from(arg))
      else
        ShallowMongoid::DocumentStub.new(arg.class, arg._id.to_s)
      end
    end
  
    def self.load(arg)
      return arg unless arg.is_a?(ShallowMongoid::DocumentStub)
      result = arg.klass.find(arg.id)
      (arg.selector || []).each do |message|
        result = result.send(*message)
      end
      result
    end
  
    # The chain of relations allowing us to locate an embedded document.
    # E.g., ['images', ['find', '4eef..678'], 'width']
    def self.selector_from(doc)
      [].tap do |selector|
        while doc._parent do
          selector.unshift ['find', doc._id.to_s] if doc.metadata.macro == :embeds_many
          selector.unshift doc.metadata.key
          doc = doc._parent
        end
      end
    end
  end
end
