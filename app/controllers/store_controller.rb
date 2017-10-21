class StoreController < ApplicationController
  before_action :set_cart
  before_action :check_outdated_cart

  def index
    @products = Product.all
  end
end
