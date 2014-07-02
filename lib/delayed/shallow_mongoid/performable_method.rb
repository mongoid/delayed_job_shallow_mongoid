module Delayed
  class PerformableMethod
    attr_accessor :object, :method_name, :args

    def initialize(object, method_name, args)
      fail NoMethodError, "undefined method `#{method_name}' for #{object.inspect}" unless object.respond_to?(method_name, true)

      self.object       = ShallowMongoid.dump(object)
      self.args         = args.map { |a| ShallowMongoid.dump(a) }
      self.method_name  = method_name.to_sym
    end

    def perform
      klass = ShallowMongoid.load(object)
      delayed_arguments = *args.map { |a| ShallowMongoid.load(a) }
      klass.send(method_name, *delayed_arguments)
    rescue Delayed::ShallowMongoid::Errors::DocumentNotFound
      return true  # do nothing if document has been removed
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
