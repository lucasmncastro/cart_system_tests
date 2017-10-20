class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
    def authenticate_user!
      if session[:user_id].blank?
        flash[:alert] = 'Enter with your username'
        redirect_to login_path
      end
    end
end
