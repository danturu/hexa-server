class Planet
  include Mongoid::Document
  include Mongoid::Orderable
  include Grid

  field :name,        type: String
  field :description, type: String

  mount_uploader :image, ImageUploader

  orderable

  validates :name,        presence: true
  validates :description, presence: true
end