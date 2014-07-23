class Api::V1::BaseController < ActionController::Metal
  include ActionController::Helpers
  include ActionController::Redirecting
  include ActionController::Rendering
  include ActionController::ConditionalGet
  include ActionController::Instrumentation
  include ActionController::Rescue
  include ActionController::ParamsWrapper
  include AbstractController::Callbacks
  include Authenticable

  wrap_parameters format: [:json]

  before_filter :allow_cross_domain

  def options
    allow_cross_domain
    head :ok
  end

private

  def allow_cross_domain
    headers["Access-Control-Allow-Origin"]   = request.env["HTTP_ORIGIN"]
    headers["Access-Control-Request-Method"] = "*"
    headers["Access-Control-Allow-Methods"]  = "PUT, OPTIONS, GET, DELETE, POST"
    headers["Access-Control-Allow-Headers"]  = "*, x-requested-with, Content-Type, Authorization, Cache-Control"
    headers["Access-Control-Max-Age"]        = "1728000"
  end
end
