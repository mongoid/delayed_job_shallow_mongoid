class TestModel
  include ::Mongoid::Document

  field :title
  field :reticulated, default: false
  embeds_many :child_models

  def reticulate!(*args)
    update_attributes!({ reticulated: true })
  end
end
