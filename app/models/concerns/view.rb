module View
  extend ActiveSupport::Concern

  included do
    field :tag,   type: String
    field :char,  type: String
    field :color, type: String
  end
end