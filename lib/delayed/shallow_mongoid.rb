module Delayed
  module ShallowMongoid
    def self.dump(arg)
      if arg.is_a?(::Mongoid::Document) && !arg.embedded?
        ShallowMongoid::DocumentStub.new(arg.class, arg._id.to_s)
      else
        arg
      end
    end
  
    def self.load(arg)
      if arg.is_a?(ShallowMongoid::DocumentStub)
        arg.klass.find(arg.id)
      else
        arg
      end
    end
  end
end
