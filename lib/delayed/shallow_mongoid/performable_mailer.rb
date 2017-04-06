module Delayed
  class PerformableMailer < PerformableMethod
    def perform
      klass = ShallowMongoid.load(object)
      delayed_arguments = *args.map { |a| ShallowMongoid.load(a) }
      message = klass.send(method_name, *delayed_arguments)
      message.respond_to?(:deliver_now) ? message.deliver_now : message.deliver
    rescue Delayed::ShallowMongoid::Errors::DocumentNotFound
      return true # do nothing if document has been removed
    end
  end
end
