class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :load_or_create_cart, only: [:index, :add]

  def index
  end

  def add
    item = @cart.items.find_or_initialize_by(product_id: params[:product_id])
    item.quantity += 1 if item.persisted?
    item.save!

    flash[:notice] = 'Item successful added'
    redirect_to root_path
  end

  def update
    @cart = @current_user.carts.find_by(status: :pending)
    if params[:commit] == 'Checkout'
      @cart.update! cart_params.merge(status: 'finished')
      redirect_to thanks_path
    else
      @cart.update! cart_params
      redirect_to root_path
    end
  end

  def thanks
  end

  private

    def cart_params
      params.require(:cart).permit(items_attributes: [:id, :quantity, :_destroy])
    end

    def load_or_create_cart
      @cart = @current_user.carts.find_or_create_by!(status: 'pending')
      if @cart.verify_expired?
        @cart.mark_as_expired!
        @cart = @current_user.carts.create!(status: 'pending')
      end
    end
end
