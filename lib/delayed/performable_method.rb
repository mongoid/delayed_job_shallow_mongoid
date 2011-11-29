module Delayed
  class PerformableMethod
    def initialize(object, method_name, args)
      raise NoMethodError, "undefined method `#{method_name}' for #{object.inspect}" unless object.respond_to?(method_name, true)

      self.object       = ShallowMongoid.dump(object)
      self.args         = args.map{|a| ShallowMongoid.dump(a) }
      self.method_name  = method_name.to_sym
    end
    
    def perform
      ShallowMongoid.load(object).send(method_name, *args.map{|a| ShallowMongoid.load(a) })
    rescue Mongoid::Errors::DocumentNotFound
      true  # do nothing if document has been removed
    end
  end
end
