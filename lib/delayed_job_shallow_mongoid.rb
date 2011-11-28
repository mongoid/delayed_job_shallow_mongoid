module Delayed
  class ShallowMongoidDocument < Struct.new(:klass, :id)
  end
  
  class PerformableMethod
    def initialize(object, method_name, args)
      raise NoMethodError, "undefined method `#{method_name}' for #{object.inspect}" unless object.respond_to?(method_name, true)

      self.object       = dump(object)
      self.args         = args.map{|a| dump(a) }
      self.method_name  = method_name.to_sym
    end
    
    def perform
      load(object).send(method_name, *args.map{|a| load(a) })
    rescue Mongoid::Errors::DocumentNotFound
      true  # do nothing if object receiving message has been removed
    end
  
  private
  
    def load(arg)
      if arg.is_a?(ShallowMongoidDocument)
        arg.klass.find(arg.id)
      else
        arg
      end
    end
    
    def dump(arg)
      if arg.is_a?(::Mongoid::Document)
        ShallowMongoidDocument.new(arg.class, arg._id.to_s)
      else
        arg
      end
    end
  end
end
