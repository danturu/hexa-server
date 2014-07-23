module Grid
  extend ActiveSupport::Concern

  included do
    field :w, type: Integer
    field :h, type: Integer

    embeds_many :plots, as: :grid, class_name: "Cell"
    embeds_many :units, as: :grid, class_name: "Cell"

    validates :w, numericality: { only_integer: true }
    validates :h, numericality: { only_integer: true }

    def actual_w
      w
    end

    def actual_h
      h * 2 - 1
    end
  end
end