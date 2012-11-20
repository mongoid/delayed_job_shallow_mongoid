class ChildModel
  include ::Mongoid::Document

  embedded_in :test_model, :inverse_of => :child_models
  embeds_many :grandchild_models
end
