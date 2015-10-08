class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to users_path
  end

  def new_session_path(scope)
    new_session_user_path
  end

  # private

  # def current_user
  # 	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  #   rescue ActiveRecord::RecordNotFound	
  # end

  # def require_login
  # 	if session[:user_id] == nil
  # 		redirect_to root_path
  # 	end
  # end

  # helper_method :require_login
  # helper_method :current_user

end
