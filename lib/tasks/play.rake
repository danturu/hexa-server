def invalid_turn
  begin
    yield
  rescue Exception => exception
    puts exception
  end
end

task :play => :environment do
  begin
    white = User.create!
    black = User.create!
    game  = Game.createFrom!(Planet.first, game_owner: white);

    game.start! black

    puts "Turn 1:"
    game.turn! from_x: 4, from_y: 0, to_x: 4, to_y: 2, player: white

    puts "Turn 2:"
    game.turn! from_x: 0, from_y: 4, to_x: 1, to_y: 3, player: black

    puts "Turn 3:"
    game.turn! from_x: 4, from_y: 2, to_x: 2, to_y: 4, player: white

    puts "Turn 3:"
    invalid_turn { game.turn! from_x: 0, from_y: 4, to_x: 1, to_y: 4, player: black }

    puts "Turn 4:"
    invalid_turn { game.turn! from_x: 8, from_y: 4, to_x: 7, to_y: 7, player: white }
  ensure
    white.destroy; black.destroy; game.destroy;
  end
end