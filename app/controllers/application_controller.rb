class ApplicationController < ActionController::Base
  include Authenticable

  protect_from_forgery with: :exception

  helper_method :current_user
end
