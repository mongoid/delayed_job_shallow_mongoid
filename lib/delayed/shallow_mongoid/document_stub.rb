module Delayed
  module ShallowMongoid
    class DocumentStub < Struct.new(:klass, :id, :selector)
      def description
        "#{klass}[#{id}]".tap do |desc|
          desc << '.' + selector.map do |s|
            s.is_a?(Array) ? "#{s.first}(#{s[1..-1].map(&:inspect).join(', ')})" : s
          end.join('.') if selector && selector.any?
        end
      end
    end
  end
end
