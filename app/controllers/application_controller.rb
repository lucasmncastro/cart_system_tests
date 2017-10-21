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
      return unless session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end

    def set_cart
      return unless @current_user

      @cart = @current_user.carts.find_or_create_by!(status: 'pending')
      if @cart.verify_expired?
        @cart.mark_as_expired!
        @cart = @current_user.carts.create!(status: 'pending')
      end
    end

    def check_outdated_cart
      return unless @cart

      if @cart.outdated?
        redirect_to outdated_cart_path
      end
    end
end
