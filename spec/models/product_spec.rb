require 'rails_helper'

RSpec.describe Product, type: :model do

  it "should have a name" do
    product = Product.new
    expect(product).not_to be_valid
    expect(product.errors[:name]).to include("can't be blank")
  end

  it "should have an unique name" do
    old_book = Product.create!(name: 'Learn RoR - Beginner', price: 24.99)
    product  = Product.new(name: old_book.name)

    expect(product).not_to be_valid
    expect(product.errors[:name]).to include("has already been taken")
  end

  it "should have a price" do
    product = Product.new
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include("can't be blank")
  end

end
