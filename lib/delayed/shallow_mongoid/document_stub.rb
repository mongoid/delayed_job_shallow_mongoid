module Delayed::ShallowMongoid
  class DocumentStub < Struct.new(:klass, :id, :selector)
    def description
      "#{klass}[#{id}]" << (selector || []).join('.')
    end
  end
end
