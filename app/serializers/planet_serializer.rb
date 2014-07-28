class PlanetSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :photo, :w, :h, :position

  def photo
    object.photo.url
  end
end
