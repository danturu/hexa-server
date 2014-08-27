task :play => :environment do
  def print(game)
    yield

    (parser = Engine::Parser.new).print \
      parser.to_matrix(w: game.actual_w, h: game.actual_h, cells: game.plots),
      parser.to_matrix(w: game.actual_w, h: game.actual_h, cells: game.units)
  rescue Engine::Errors::Error => ex
    Rails.logger.error ex
  end

  begin
    white_player = User.create!
    black_player = User.create!

    game = Game.createFrom! Planet.first, owner: white_player
    game.start black_player

    puts "Turn 1:"
    print(game) { game.turn! from_x: 4, from_y: 0, to_x: 4, to_y: 2, player: white_player }

    puts "Turn 2:"
    print(game) { game.turn! from_x: 0, from_y: 4, to_x: 1, to_y: 3, player: black_player }

    puts "Turn 3:"
    print(game) { game.turn! from_x: 4, from_y: 2, to_x: 2, to_y: 4, player: white_player }

    puts "Turn 4:"
    print(game) { game.turn! from_x: 0, from_y: 4, to_x: 1, to_y: 4, player: black_player }

    puts "Turn 5:"
    print(game) { game.turn! from_x: 8, from_y: 4, to_x: 6, to_y: 8, player: black_player }

    puts "Turn 6:"
    print(game) { game.turn! from_x: 8, from_y: 3, to_x: 7, to_y: 7, player: black_player }

    puts "Turn 7:"
    print(game) { game.turn! from_x: 4, from_y: 0, to_x: 5, to_y: 1, player: black_player }

    puts "Turn 8:"
    print(game) { game.turn! from_x: 8, from_y: 4, to_x: 7, to_y: 7, player: white_player }
  ensure
    white_player.destroy; black_player.destroy; game.destroy;
  end
end
