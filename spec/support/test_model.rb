class TestModel
  include ::Mongoid::Document

  field :title
  embeds_many :child_models
end
