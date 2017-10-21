class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: [:index, :add, :accept_changes, :reject_changes, :outdated]
  before_action :check_outdated_cart, only: [:index, :add]

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

  def accept_changes
    @cart.accept_changes!
    redirect_to root_path
  end

  def reject_changes
    @cart.reject_changes!
    redirect_to root_path
  end

  private

    def cart_params
      params.require(:cart).permit(items_attributes: [:id, :quantity, :_destroy])
    end
end
