require "matrix"

class Engine::Parser
  using Base::MutableMatrix

  def from_matrix(map, *filter)
    @matrix = Matrix[*map.clone.split("\n").map {|row| row.split(" ") }]

    [].tap do |cells|
      @matrix.row_vectors.each_with_index do |row, y|
        row.each_with_index do |sign, x|
          next if filter.exclude? sign

          cells.push x: x, y: y, sign: sign if filter.include?(sign)
        end
      end
    end
  end

  def to_matrix(w:, h:, cells:)
    Matrix.build(w, h) { nil }.tap do |matrix|
      cells.each {|cell| matrix[cell.x, cell.y] = cell }
    end
  end

  def print(*layers)
    formatted = Matrix.build(layers.first.column_size, layers.first.row_size) {|x, y| grid x, y }

    layers.each do |matrix|
      matrix.row_vectors.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          next if cell.nil?

          formatted[x, y] = char(cell)
        end
      end
    end

    formatted.row_vectors.each_with_index {|row, index| puts row.to_a.join(" ") }
  end

private

  def grid(x, y)
    ["-", "|", "-"][(x & 1) + (y & 1)]
  end

  def char(cell)
    cell.object.char.send cell.object.color
  end
end
