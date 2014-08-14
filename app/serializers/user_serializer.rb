class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar_url

  has_many :games

  def avatar_url
    object.avatar.url :square
  end
end
