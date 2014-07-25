class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  include Engine::Base
  include Engine::Errors
  include Grid

  field :against_ai, type: Boolean
  field :w,          type: Integer
  field :h,          type: Integer

  belongs_to :planet,                           index: true
  belongs_to :game_owner,   class_name: "User", index: true
  belongs_to :turn_of,      class_name: "User", index: true
  belongs_to :white_player, class_name: "User", index: true
  belongs_to :black_player, class_name: "User", index: true

  validates :game_owner, presence: true

  state_machine :state, :initial => :waiting do
    before_transition :waiting => :playing do |game, transition|
      game.prepare! transition.args.first

      game.print if Rails.env.development?
    end

    before_transition :playing => same do |game, transition|
      game.move! *transition.args
      game.opponent_turn!

      game.print if Rails.env.development?
    end

    event :start do
      transition :waiting => :playing
    end

    event :turn do
      transition :playing => same
    end

    event :finish do
      transition :playing => :finished
    end
  end

  def self.createFrom!(planet, game_owner:, against_ai: false)
    create! do |game|
      game.game_owner = game_owner
      game.against_ai = against_ai

      # generating map...

      game.w = planet.w
      game.h = planet.h
      planet.plots.each {|plot| game.plots.build plot.attributes.except("_id") }
      planet.units.each {|unit| game.units.build unit.attributes.except("_id") }
    end
  end

  def prepare!(opponent)
    raise InvalidOpponentError, "Сan't play without opponent" unless player? opponent
    raise AgainstItselfError, "Сan't play against itself" unless opponent? opponent

    self.turn_of      = game_owner
    self.white_player = game_owner
    self.black_player = opponent
  end

  def start!(*args)
    raise AlreadyStartedError, "Game has already started" unless can_start?
    super
  end

  def white_units
    units.where "metadata.owner" => "white"
  end

  def black_units
    units.where "metadata.owner" => "black"
  end

  def print
    parser = (@@parser ||= Engine::Parser.new)

    parser.print parser.to_matrix(w: actual_w, h: actual_h, cells: plots),
                 parser.to_matrix(w: actual_w, h: actual_h, cells: units)
  end
end