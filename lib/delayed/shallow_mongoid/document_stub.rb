# frozen_string_literal: true

module Delayed
  module ShallowMongoid
    DocumentStub = Struct.new(:klass, :id, :selector) do
      def description
        path = (selector || []).map do |step|
          step.is_a?(Array) ? "#{step.first}(#{step[1..].map(&:inspect).join(', ')})" : step
        end
        ["#{klass}[#{id}]", *path].join('.')
      end
    end
  end
end
