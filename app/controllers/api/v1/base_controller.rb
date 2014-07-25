class Api::V1::BaseController < ActionController::Metal
  include AbstractController::Rendering
  include AbstractController::Callbacks
  include ActionController::Head
  include ActionController::Helpers
  include ActionController::Redirecting
  include ActionController::Rendering
  include ActionController::ConditionalGet
  include ActionController::Serialization
  include ActionController::StrongParameters
  include ActionController::ParamsWrapper
  include ActionController::Rescue
  include ActionController::Instrumentation
  include ActionController::Renderers::All
  include Doorkeeper::Helpers::Filter
  include Authenticable
  include Pundit

  rescue_from Mongoid::Errors::DocumentNotFound, with: :missing_resource
  rescue_from Mongoid::Errors::Validations,      with: :invalid_resource
  rescue_from Mongoid::Errors::InvalidFind,      with: :invalid_request
  rescue_from Pundit::NotAuthorizedError,        with: :not_authorized

  wrap_parameters format: [:json]

  before_filter :allow_cross_domain

  doorkeeper_for :all

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

  def missing_resource(ex)
    render json: { error: ex.class.name.demodulize }, status: :not_found
  end

  def invalid_resource(ex)
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  end

  def invalid_request(ex)
    render json: { error: ex.class.name.demodulize }, status: :unprocessable_entity
  end

  def not_authorized(ex)
    render json: { error: ex.class.name.demodulize }, status: :forbidden
  end
end