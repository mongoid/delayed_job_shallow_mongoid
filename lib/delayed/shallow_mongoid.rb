# frozen_string_literal: true

module Delayed
  module ShallowMongoid
    module Errors
      class DocumentNotFound < StandardError
      end
    end

    def self.dump(arg)
      return arg unless arg.is_a?(::Mongoid::Document) && arg.persisted?
      return arg if arg._updates.any? && !Delayed::Worker.delay_jobs

      if arg.embedded?
        Delayed::ShallowMongoid::DocumentStub.new(arg._root.class, arg._root._id.to_s, selector_from(arg))
      else
        Delayed::ShallowMongoid::DocumentStub.new(arg.class, arg._id.to_s)
      end
    end

    def self.load(arg)
      return arg unless arg.is_a?(Delayed::ShallowMongoid::DocumentStub)

      begin
        result = arg.klass.find(arg.id)
        raise Delayed::ShallowMongoid::Errors::DocumentNotFound unless result

        (arg.selector || []).each do |message|
          result = result.send(*message)
          raise Delayed::ShallowMongoid::Errors::DocumentNotFound unless result
        end
      rescue Mongoid::Errors::DocumentNotFound
        raise Delayed::ShallowMongoid::Errors::DocumentNotFound
      end

      result
    end

    # The chain of relations allowing us to locate an embedded document.
    # E.g., ['images', ['find', '4eef..678'], 'width']
    def self.selector_from(doc)
      [].tap do |selector|
        while doc._parent
          association = Delayed::ShallowMongoid.metadata(doc)
          many = if association.respond_to?(:macro)
                   association.macro == :embeds_many
                 else
                   association.is_a?(::Mongoid::Association::Embedded::EmbedsMany)
                 end
          selector.unshift ['find', doc._id.to_s] if many
          selector.unshift association.key
          doc = doc._parent
        end
      end
    end
  end
end
