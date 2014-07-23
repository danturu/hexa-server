class Planet
  include Mongoid::Document
  include Mongoid::Orderable
  include Grid

  field :name,        type: String
  field :description, type: String

  mount_uploader :photo, PhotoUploader

  orderable

  validates :name,        presence: true
  validates :description, presence: true
end