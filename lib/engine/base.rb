class Engine::Base
  module MutableMatrix
    refine Matrix do
      def []=(x, y, value)
        @rows[x][y] = value
      end
    end
  end
end