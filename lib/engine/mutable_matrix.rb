require "matrix"

module Engine::MutableMatrix
  refine Matrix do
    def []=(x, y, value)
      @rows[x][y] = value
    end
  end
end