module Delayed
  class PerformableMethod
    def initialize(object, method_name, args)
      raise NoMethodError, "undefined method `#{method_name}' for #{object.inspect}" unless object.respond_to?(method_name, true)

      self.object       = ShallowMongoid.dump(object)
      self.args         = args.map{|a| ShallowMongoid.dump(a) }
      self.method_name  = method_name.to_sym
    end
    
    def perform
      begin
        klass = ShallowMongoid.load(object)
        delayed_arguments = *args.map{|a| ShallowMongoid.load(a) }
      rescue Mongoid::Errors::DocumentNotFound
        return true  # do nothing if document has been removed
      end
      klass.send(method_name, *delayed_arguments)
    end
    
    def display_name
      if object.is_a?(ShallowMongoid::DocumentStub)
        "#{object.description}##{method_name}"
      else
        "#{object.class}##{method_name}"
      end
    end
  end
end
