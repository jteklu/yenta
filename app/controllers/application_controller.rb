class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
  	@current_user ||= User.find(session[:users_id]) if session[:users_id]	
  end

  def require_login
  	if session[:users_id] == nil
  		redirect_to root_path
  	end
  end

  helper_method :require_login
  helper_method :current_user

end
