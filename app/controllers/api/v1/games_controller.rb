class Api::V1::GamesController < Api::V1::BaseController
  def show
    render json: current_user.games.find(params[:id])
  end

  def create
    game = Game.createFrom! Planet.find(params[:planet_id]), game_owner: current_user
    render json: game
  end

  def invite
    NotificationMailer.invitation(current_user.games.find(params[:id]), params[:email]).deliver
    render json: {}, status: :ok
  end

  def join
    game = Game.find(params[:id]).tap {|game| game.start! current_user }
    render json: game
  rescue Engine::Errors::AlreadyStartedError => ex
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  rescue Engine::Errors::InvalidOpponentError => ex
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  rescue Engine::Errors::AgainstItselfError => ex
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  end

  def turn
    game = current_user.games.find(params[:id]).tap {|game| game.turn! turn_params }
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
