class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location

  def store_location
    return unless request.get?
    if (request.path != login_path &&
      request.path != logout_path &&
      !request.xhr?)
      session[:return_route] = request.fullpath
    end
  end
end
