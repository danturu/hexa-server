class User
  include Mongoid::Document

  field :name,     type: String
  field :email,    type: String
  field :provider, type: String
  field :uid,      type: String

  has_and_belongs_to_many :games

  def self.from_provider(auth)
    where(auth.slice("provider", "uid")).first || create_from_provider!(auth)
  end

  def self.create_from_provider!(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid      = auth["uid"]
      user.name     = auth["info"]["name"]
    end
  end
end