module Delayed::ShallowMongoid
  class DocumentStub < Struct.new(:klass, :id)
    def display_name
      "#{klass}[#{id}]##{method_name}"
    end
  end
end
