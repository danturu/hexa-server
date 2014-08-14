class User
  include Mongoid::Document

  field :name,     type: String
  field :email,    type: String
  field :provider, type: String
  field :uid,      type: String

  mount_uploader :avatar, PhotoUploader

  has_and_belongs_to_many :games, index: true

  def self.from_provider(auth)
    where(auth.slice("provider", "uid")).first || create_from_provider!(auth)
  end

  def self.create_from_provider!(auth)
    create! do |user|
      user.provider          = auth["provider"]
      user.uid               = auth["uid"]
      user.name              = auth["info"]["name"]
      user.remote_avatar_url = auth["info"]["image"]
    end
  end
end
