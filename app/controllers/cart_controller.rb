class CartController < ApplicationController
  before_action :authenticate_user!, only: [:index, :add]

  def index
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
  end

  def checkout
  end
end
