class SessionsController < ApplicationController
  def create
    user = User.from_provider omniauth_auth

    session[:user_id] = user.id.to_s
    session[:facebook_token]            = omniauth_auth[:credentials][:token]
    session[:facebook_token_expires_at] = omniauth_auth[:credentials][:expires_at]

    redirect_to(omniauth_params[:return_to] || root_url)
  end

  def destroy
    [:user_id, :facebook_token, :facebook_token_expires_at].each do |key|
      session.delete key
    end

    redirect_to root_path
  end

private

  def omniauth_auth
    @omniauth_auth ||= env["omniauth.auth"].with_indifferent_access
  end

  def omniauth_params
    @omniauth_params ||= env["omniauth.params"].with_indifferent_access
  end
end
