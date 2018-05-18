class ApplicationController < ActionController::Base
  respond_to :html
  responders :flash, :http_cache, :collection

  helper_method :current_user
  before_action :require_login

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    unless current_user.present?
      flash[:error] = t('require_login')
      redirect_to [:new, :session]
    end
  end
end
