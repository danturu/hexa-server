class PagesController < ApplicationController
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper

  skip_before_action :verify_authenticity_token, only: :canvas
  after_action :allow_frame, only: :canvas

  def home
  end

  def canvas
    if current_user and not facebook_token_expired?
      games = facebook_request_ids.map do |request_id|
        parse_facebook_request request_id
      end

      # redirect to most recent game...

      redirect_to game_url games.compact.last
    else
      js_redirect = javascript_tag <<-JS
        top.location = "/auth/facebook?#{facebook_params.to_query}"
      JS

      # redirect from facebook canvas...

      render text: js_redirect
    end
  end

protected

  def allow_frame
    response.headers["X-Frame-Options"] = "ALLOW-FROM https://apps.facebook.com"
  end

  def game_url(game)
    URI::join(ENV["GAME_CLIENT_URL"], game.try(:id).to_s).to_s
  end

  def facebook_params
    { signed_request: params[:signed_request], return_to: env["HTTP_REFERER"] }
  end

  def facebook_request_ids
    params[:request_ids].to_s.split(",")
  end

  def parse_facebook_request(request_id)
    request_token = [request_id, current_user.uid].join("_")

    facebook_client.get_object(request_token) do |request|
      data = JSON.parse(request["data"].to_s).with_indifferent_access

      Game.find(data[:game_id]).tap do |game|
        if data[:action_name] == "invite"
          game.start current_user
        end
      end
    end
  rescue Koala::Facebook::APIError, JSON::ParserError, Mongoid::Errors::DocumentNotFound => ex
    logger.error ex
  ensure
    facebook_client.delete_object(request_token) rescue Koala::Facebook::ClientError
  end
end
