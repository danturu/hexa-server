class GameSerializer < ActiveModel::Serializer
  attributes :id, :state, :w, :h, :game_owner_id, :turn_of_id

  has_many :plots
  has_many :units

  has_one :planet
  has_one :white_player
  has_one :black_player
end
