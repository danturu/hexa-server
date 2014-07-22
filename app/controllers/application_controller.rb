class ApplicationController < ActionController::Base
  include Authenticable

  protect_from_forgery with: :exception

  helper_method :current_user

  def launch
    if current_user
      redirect_to game_path
    else
      redirect_to root_path
    end
  end

private

  def game_path
    ENV["GAME_URI"]
  end
end
