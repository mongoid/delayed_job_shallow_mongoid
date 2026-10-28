# frozen_string_literal: true

class GrandchildModel
  include ::Mongoid::Document

  embedded_in :child_model, inverse_of: :grandchild_models
end
