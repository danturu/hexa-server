module View
  extend ActiveSupport::Concern

  included do
    field :tag,  type: String
    field :char, type: String

    embeds_many :images, as: :view, class_name: "Image"
  end
end