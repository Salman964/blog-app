# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action proc { |controller|
                  if controller.request.xhr?
                    (controller.action_has_layout = false)
                  end
                }
  # protect_from_forgery with: :null_session
  include Pundit::Authorization
  include ActiveModel::Serialization
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found
  # rescue_from Exception, with: :not_found
  # rescue_from ActionController::RoutingError, with: :not_found
  # # rescue_from ActionController::UnknownController, with: :not_found

  def raise_not_found
    raise ActionController::RoutingError, "No route matches #{params[:unmatched_route]}"
  end

  def not_found
    render file: "public/404", status: :not_found, formats: [:html]
  end

  def error
    render file: "public/500", status: :not_found, formats: [:html]
  end
end

def after_sign_out_path_for(_resource_or_scope)
  root_path
end
