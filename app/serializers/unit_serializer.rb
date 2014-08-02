class UnitSerializer < ActiveModel::Serializer
  attributes :id, :tag

  has_many :images
end
