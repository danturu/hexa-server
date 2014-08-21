module MailHelper
  def join_url(game)
    "#{ENV["GAME_URI"]}/#{game.id.to_s}/join"
  end
end
