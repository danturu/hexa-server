module Authenticable
  extend ActiveSupport::Concern

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end