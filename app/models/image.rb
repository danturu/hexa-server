class Image
  include Mongoid::Document

  field :tag,      type: String
  field :sprite_w, type: Integer
  field :sprite_h, type: Integer

  mount_uploader :file, ImageUploader

  embedded_in :view, polymorphic: true

  validates :sprite_w, numericality: { only_integer: true }
  validates :sprite_h, numericality: { only_integer: true }
end