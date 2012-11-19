module Delayed
  class PerformableMailer < PerformableMethod
    def perform
      ShallowMongoid.load(object).send(method_name, *args.map{|a| ShallowMongoid.load(a) }).deliver
    end
  end
end
