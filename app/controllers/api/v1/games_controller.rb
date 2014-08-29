class Api::V1::GamesController < Api::V1::BaseController
  def show
    render json: current_user.games.find(params[:id])
  end

  def create
    render json: Game.createFrom!(params[:planet_id], game_params)
  end

  def turn
    current_user.games.find(params[:id]).tap do |game|
      game.turn! turn_params
    end

    render json: {}, status: :ok
  rescue Engine::Errors::Error => ex
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  end

  def destroy
    current_user.games.find(params[:id]).tap do |game|
      if game.playing? then game.leave! else game.destroy! end
    end

    render json: {}, status: :ok
  end

protected

  def game_params
    { owner: current_user, metadata: { opponent: params[:opponent] } }
  end

  def turn_params
    params.slice(:from_x, :from_y, :to_x, :to_y).merge(player: current_user).symbolize_keys
  end
end
