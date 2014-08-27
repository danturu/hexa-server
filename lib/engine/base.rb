require "matrix"

module Engine::Base
  # include Engine::Events
  include Engine::Errors

  module MutableMatrix
    refine Matrix do
      def []=(x, y, value)
        @rows[x][y] = value
      end

      def [] (x, y)
        x < 0 || y < 0 ? nil : super(x, y)
      end
    end
  end

  def opponent?(opponent)
    game_owner != opponent
  end

  def player?(candidate)
    candidate.is_a? User
  end

  def can_turn_now?(player)
    turn_of == player
  end

  def can_control_unit?(unit, player)
    unit.metadata[:owner] == (player == white_player ? "white" : "black")
  end

  def move!(from_x:, from_y:, to_x:, to_y:, player:)
    raise OpponentTurnError, "It isn't your turn to move" unless can_turn_now? player

    from_x = from_x.to_i
    from_y = from_y.to_i
    to_x   = to_x.to_i
    to_y   = to_y.to_i

    unit = units.where(x: from_x, y: from_y).first

    raise InvalidTurnError, "No unit was found" unless unit
    raise InvalidTurnError, "Enemy unit not yours" unless can_control_unit? unit, player

    if replication? from_x, from_y, to_x, to_y
      infect replicate(unit, to_x, to_y)
    else
      infect translate(unit, to_x, to_y)
    end

    opponent_turn!
  end

  def opponent_turn!
    self.turn_of = opponent
    check_is_finish
  end

  def opponent(player = turn_of)
    player == black_player ? white_player : black_player
  end

protected

  def check_is_finish
    # ...
  end

  # | x | 3 | x |
  # x | 3 | 3 | x
  # | 3 | 2 | 3 |
  # 3 | 2 | 2 | 3
  # | 2 | 1 | 2 |
  # 3 | 1 | 1 | 3
  # | 2 | U | 2 |
  # 3 | 1 | 1 | 3
  # | 2 | 1 | 2 |
  # 3 | 2 | 2 | 3
  # | 3 | 2 | 3 |
  # x | 3 | 3 | x
  # | x | 3 | x | etc...

  def perimeter(x, y, r)
    return [
      { x: x - 0, y: y - 2 },
      { x: x - 1, y: y - 1 }, { x: x + 1, y: y - 1 },
      { x: x - 1, y: y + 1 }, { x: x + 1, y: y + 1 },
      { x: x - 0, y: y + 2 },
    ] if r == 1

    return [
      { x: x - 0, y: y - 4 },
      { x: x - 1, y: y - 3 }, { x: x + 1, y: y - 3 },
      { x: x - 2, y: y - 2 }, { x: x + 2, y: y - 2 },
      { x: x - 2, y: y - 0 }, { x: x + 2, y: y - 0 },
      { x: x - 2, y: y + 2 }, { x: x + 2, y: y + 2 },
      { x: x - 1, y: y + 3 }, { x: x + 1, y: y + 3 },
      { x: x - 0, y: y + 4 },
    ] if r == 2
  end

  def replication?(from_x, from_y, to_x, to_y)
    (to_x - from_x).abs < 2 and (to_y - from_y).abs < 3
  end

  def occupied?(x, y)
    not (plots.where(x: x, y: y).exists? or units.where(x: x, y: y).exists?)
  end

  def translate(unit, x, y)
    raise InvalidTurnError, "Can't translate where: #{[unit.x, unit.y].to_json} => #{[x, y].to_json}" if perimeter(unit.x, unit.y, 2).exclude?(x: x, y: y) or occupied?(x, y)

    unit.update x: x, y: y
    unit
  end

  def replicate(unit, x, y)
    raise InvalidTurnError, "Can't replicate where: #{[unit.x, unit.y].to_json} => #{[x, y].to_json}" if perimeter(unit.x, unit.y, 1).exclude?(x: x, y: y) or occupied?(x, y)

    replicated = units.create! unit.attributes.except("_id").merge(x: x, y: y)
    replicated
  end

  def infect(unit)
    enemies = units.where(:"metadata.owner".ne => unit.metadata[:owner]).or(perimeter(unit.x, unit.y, 1))

    enemies.each do |enemy|
      enemy.destroy
      units.create! unit.attributes.except("_id").merge(x: enemy.x, y: enemy.y)
    end
  end
end
