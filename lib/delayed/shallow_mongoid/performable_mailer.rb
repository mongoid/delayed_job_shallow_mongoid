module Delayed
  class PerformableMailer
    def perform
      begin
        klass = ShallowMongoid.load(object)
        return true unless klass
        delayed_arguments = *args.map{|a| ShallowMongoid.load(a) }
      rescue Mongoid::Errors::DocumentNotFound
        return true  # do nothing if document has been removed
      end
      klass.send(method_name, *delayed_arguments).deliver
    end
  end
end
