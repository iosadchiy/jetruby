class ApplicationController < ActionController::Base
  respond_to :html
  responders :flash, :http_cache, :collection

  helper_method :current_user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
