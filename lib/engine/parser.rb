require "matrix"

class Engine::Parser
  using Engine::Base::MutableMatrix

  def from_matrix(map, *filter)
    @matrix = Matrix[*map.clone.split("\n").map {|row| row.split(" ") }]

    [].tap do |cells|
      @matrix.row_vectors.each_with_index do |row, y|
        row.each_with_index do |char, x|
          cells.push x: x, y: y, char: char if filter.include? char
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
          formatted[x, y] = char(cell) if cell.present?
        end
      end
    end

    print_vertical_indexes formatted.column_size

    formatted.row_vectors.each_with_index do |row, index|
      horizontal = index.to_s.last.blue
      puts "#{horizontal} #{row.to_a.join(' ')} #{horizontal}"
    end

    print_vertical_indexes formatted.column_size

    true
  end

private

  def grid(x, y)
    ["-", "|", "-"][(x & 1) + (y & 1)]
  end

  def char(cell)
    cell.object.char.green
  end

  def print_vertical_indexes(size)
    vertical = (0..size - 1).map(&:to_s).map(&:last).join(" ")
    puts "+ #{vertical} +".blue
  end
end
