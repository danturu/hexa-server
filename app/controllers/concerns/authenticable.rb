module Authenticable
  extend ActiveSupport::Concern

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def facebook_token
    session[:facebook_token]
  end

  def facebook_token_expired?
    session[:facebook_token_expires_at].to_i < Time.zone.now.to_i
  end
end
