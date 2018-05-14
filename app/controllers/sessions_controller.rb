class SessionsController < ApplicationController
  def create
    reset_session
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    reset_session
    session[:user_id] = nil
    redirect_to root_path
  end
end
