class User
  include Mongoid::Document

  field :name,     type: String
  field :email,    type: String
  field :provider, type: String
  field :uid,      type: String

  mount_uploader :avatar, PhotoUploader

  has_and_belongs_to_many :games, index: true, inverse_of: nil

  def self.from_provider(auth, avatar_url=nil)
    where(auth.slice(:provider, :uid)).first || create_from_provider!(auth, avatar_url)
  end

  def self.create_from_provider!(auth, avatar_url=nil)
    info = auth[:info]

    create! do |user|
      user.provider = auth[:provider]
      user.uid      = auth[:uid]
      user.name     = info[:name]
      user.email    = info[:email]

      avatar_url.try(:call).tap do |url|
        user.remote_avatar_url = url if url.present?
      end
    end
  end
end
