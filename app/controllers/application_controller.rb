require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js, :json

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    error_message = exception.message
    respond_to do |format|
      format.html { redirect_to root_path, alert: error_message }
      format.js { render status: 403 }
      format.json { render json: { error: error_message}, status: 403 }
    end
  end
end
