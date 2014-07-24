class Api::V1::GamesController < Api::V1::BaseController
  def index
    render json: current_user.games
  end

  def show
    render json: current_user.games.find(params[:id])
  end

  def create
    game = Game.createFrom! Planet.find(params[:planet_id]), game_owner: current_user
    render json: game
  end

  def join
    game = Game.find(params[:id]).tap {|game| game.start! current_user }
    render json: game
  rescue Engine::Errors::InvalidOpponentError => ex
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  rescue Engine::Errors::AgainstItselfError => ex
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  end

  def turn
    game = Game.find(params[:id]).tap {|game| game.turn! turn_params } # ({from_x: 4, from_y: 0, to_x: 4, to_y: 3, player: User.first}) }  # turn_params }
    render json: {}, status: :ok
  rescue Engine::Errors::OutOfTurn => ex
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  rescue Engine::Errors::InvalidMovement => ex
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  end

protected

  def turn_params
    params.slice(:from_x, :from_y, :to_x, :to_y).merge(player: current_user).symbolize_keys
  end
end