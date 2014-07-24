class PlanetSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :photo, :w, :h

  def photo
    object.photo.url
  end
end
