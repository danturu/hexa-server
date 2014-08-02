class PlanetSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image_url, :position

  def image_url
    object.image.url
  end
end
