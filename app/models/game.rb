class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  include Grid

  field :against_ai, type: Boolean
  field :w,          type: Integer
  field :h,          type: Integer

  belongs_to :planet,                           index: true
  belongs_to :game_owner,   class_name: "User", index: true
  belongs_to :white_player, class_name: "User", index: true
  belongs_to :black_player, class_name: "User", index: true

  def self.createFrom!(planet:, game_owner:, against_ai: false)
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
end