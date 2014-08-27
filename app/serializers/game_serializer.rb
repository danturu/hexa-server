class GameSerializer < ActiveModel::Serializer
  attributes :id, :state, :metadata, :w, :h, :turn_of_id, :planet_id, :event_name, :event_time

  has_many :plots
  has_many :units

  has_one :white_player, serializer: PlayerSerializer
  has_one :black_player, serializer: PlayerSerializer
end
