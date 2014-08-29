class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  include Engine::Base
  include Engine::Errors
  include Grid

  field :metadata,   type: Hash
  field :event_name, type: String
  field :event_time, type: DateTime

  belongs_to :planet,                           index: true
  belongs_to :white_player, class_name: "User", index: true
  belongs_to :black_player, class_name: "User", index: true
  belongs_to :turn_of,      class_name: "User", index: true

  # game.trigger transition.event, PlayerSerializer.new(game.black_player).to_json

  state_machine :state do
    before_transition :waiting => :playing do |game, transition|
      game.join! transition.args.first
    end

    before_transition :playing => same do |game, transition|
      game.move! *transition.args
    end

    before_transition do |game, transition|
      game.log transition.event
    end

    event :invite do
      transition nil => :waiting
    end

    event :start do
      transition :waiting => :playing
    end

    event :turn do
      transition :playing => same
    end

    event :leave do
      transition :playing => :finished
    end

    event :finish do
      transition :playing => :finished
    end
  end

  after_create :invite!

  after_save do
    white_player.games << self if white_player_id_changed? and white_player.is_a? User
    black_player.games << self if black_player_id_changed? and black_player.is_a? User
  end

  def self.createFrom!(planet_id, metadata: {}, owner:)
    planet = Planet.find planet_id

    create! do |game|
      game.white_player = owner
      game.turn_of      = owner

      game.metadata = metadata
      game.planet   = planet
      game.w        = planet.w
      game.h        = planet.h

      planet.plots.each {|plot| game.plots.build plot.attributes.except "_id" }
      planet.units.each {|unit| game.units.build unit.attributes.except "_id" }
    end
  end

  def log(event)
    self.event_name = event
    self.event_time = Time.now
  end

  def trigger(event, data={})
    Pusher.trigger channel, event, data
  end

  def channel
    [:presence, :game, id].join("-")
  end

  def white_units
    units.where "metadata.owner" => "white"
  end

  def black_units
    units.where "metadata.owner" => "black"
  end
end
