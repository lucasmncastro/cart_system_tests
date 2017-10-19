class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  before_validation :set_unit_price,  if: :product
  before_validation :set_total_price, if: :product

  private

  def set_unit_price
    self.unit_price = product.price
  end

  def set_total_price
    self.total_price = product.price * quantity
  end
end
