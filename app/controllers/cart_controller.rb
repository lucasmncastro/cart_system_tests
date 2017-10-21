class CartController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart = @current_user.carts.find_or_create_by!(status: 'pending')
  end

  def add
    @user = User.find(session[:user_id])
    @cart = @user.carts.find_or_create_by!(status: :pending)

    item = @cart.items.find_or_initialize_by(product_id: params[:product_id])
    item.quantity += 1 if item.persisted?
    item.save!

    flash[:notice] = 'Item successful added'
    redirect_to root_path
  end

  def update
    @cart = @current_user.carts.find_by(status: :pending)
    @cart.update! cart_params
    redirect_to root_path
  end

  def checkout
  end

  private

    def cart_params
      params.require(:cart).permit(items_attributes: [:id, :quantity])
    end
end
