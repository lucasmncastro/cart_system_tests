class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_current_user

  protected
    def authenticate_user!
      if session[:user_id].blank?
        flash[:alert] = 'Enter with your username'
        redirect_to login_path
      end
    end

    def set_current_user
      if session[:user_id]
        @current_user = User.find(session[:user_id])
      end
      return true
    end
end
