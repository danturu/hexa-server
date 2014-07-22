class SessionsController < ApplicationController
  def create
    user = User.from_provider env["omniauth.auth"]
    session[:user_id] = user.id.to_s

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end
end