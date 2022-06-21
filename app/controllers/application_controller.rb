# frozen_string_literal: true

class ApplicationController < ActionController::Base

  # protect_from_forgery with: :null_session
  # include Pundit::Authorization
  include ActiveModel::Serialization
  #rescue_from ActiveRecord::RecordNotFound, with: :not_found 
  # rescue_from Exception, with: :not_found
  # rescue_from ActionController::RoutingError, with: :not_found
  # # rescue_from ActionController::UnknownController, with: :not_found
  
  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end
  
  def not_found
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end
  
  def error
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/500", layout: false, status: :error }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end

  def after_sign_out_path_for(resource_or_scope)        
    root_path
   end 

end
