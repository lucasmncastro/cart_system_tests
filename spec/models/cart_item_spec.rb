require 'rails_helper'

RSpec.describe CartItem, type: :model do

  it "should belongs to a cart" do
    item = CartItem.new
    expect(item).not_to be_valid
    expect(item.errors[:cart]).to include('must exist')
  end

  it "should have the quantity equal to one by default" do
    item = CartItem.new
    expect(item.quantity).to eq(1)
  end

  it "should not allow quantity lower than one" do
    item = CartItem.new
    item.quantity = 0
    expect(item).not_to be_valid
    expect(item.errors[:quantity]).to include('must be greater than 0')
  end

  it "should copy the unit price from the product on saving" do
    book = Product.create!(name: 'My Book', price: 9.99)
    cart = CartItem.new(product: book)
    cart.save
    expect(cart.unit_price).to eq(9.99)
  end

  it "should calculate the total price on saving" do
    book = Product.create!(name: 'My Book', price: 9.99)
    cart = CartItem.new(product: book, quantity: 3)
    cart.save
    expect(cart.total_price).to eq(9.99 * 3)
  end
end
