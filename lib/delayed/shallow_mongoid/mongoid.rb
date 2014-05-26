module Delayed
  module ShallowMongoid
    def self.mongoid3?
      ::Mongoid.const_defined? :Observer # deprecated in Mongoid 4.x
    end

    def self.metadata instance
      if Delayed::ShallowMongoid.mongoid3?
        instance.metadata
      else
        instance.relation_metadata
      end
    end
  end
end
