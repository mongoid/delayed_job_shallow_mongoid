module Delayed
  class PerformableMailer < PerformableMethod
    def perform
      klass = ShallowMongoid.load(object)
      delayed_arguments = *args.map { |a| ShallowMongoid.load(a) }
      klass.send(method_name, *delayed_arguments).deliver
    rescue Delayed::ShallowMongoid::Errors::DocumentNotFound
      return true  # do nothing if document has been removed
    end
  end
end
