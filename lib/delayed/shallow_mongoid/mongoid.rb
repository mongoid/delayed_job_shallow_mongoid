# frozen_string_literal: true

module Delayed
  module ShallowMongoid
    def self.mongoid3?
      ::Mongoid.const_defined? :Observer # deprecated in Mongoid 4.x
    end

    def self.metadata(instance)
      if Delayed::ShallowMongoid.mongoid3?
        instance.metadata
      elsif instance.respond_to?(:_association)
        instance._association
      else
        instance.relation_metadata
      end
    end
  end
end
