class Api::V1::MessagesController < Api::V1::BaseController
  def subscribe
    tokens = channels.each_with_object({}) do |channel, tokens|
      tokens[channel] = Messages.sign(channel, id: current_user.id.to_s)
    end

    render json: tokens
  end

protected

  def channels
    params[:channels].to_a & current_user.games.not.where(state: "finished").map(&:channel)
  end
end
