module Delayed
  module ShallowMongoid
    def self.dump(arg)
      return arg unless arg.is_a?(::Mongoid::Document)
      if arg.embedded?
        ShallowMongoid::DocumentStub.new(arg._root.class, arg._root._id.to_s, selector_from(arg._path))
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
    
    # E.g., "images.0.width"  =>  ["images", ["[]", 0], "width"]
    def self.selector_from(path)
      [].tap do |selector|
        path.split('.').each do |message|
          selector << message =~ /^0-9+$/ ? ["[]", message.to_i] : message
        end
      end
    end
  end
end
