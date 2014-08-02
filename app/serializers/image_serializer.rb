class ImageSerializer < ActiveModel::Serializer
  attributes :id, :tag, :sprite_w, :sprite_h, :url

  def url
    object.file.url
  end
end
