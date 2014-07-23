class Cell
  include Mongoid::Document

  field :x,        type: Integer
  field :y,        type: Integer
  field :metadata, type: Hash

  index({ x: 1, y: 1 }, { unique: true })

  embedded_in :grid, polymorphic: true

  # May be one of following: Unit, Plot or Bonus that will be introduced later.

  belongs_to :object, polymorphic: true

  validates :x, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: Proc.new {|cell| cell.grid.actual_w } }
  validates :y, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: Proc.new {|cell| cell.grid.actual_h } }
  validates :object, presence: true, uniqueness: { scope: [:x, :y] }
end