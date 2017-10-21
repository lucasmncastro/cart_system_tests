require 'rails_helper'

RSpec.describe "Answers:" do
  before(:each) do
    @diogo = User.create! name: 'Diogo'
    @joao  = User.create! name: 'João'

    @book1 = Product.create! name: 'Learn RoR - Beginner', price: 24.99
    @book2 = Product.create! name: 'Mastering RoR - Level over 9000	', price: 9001.00

    # First time of Diogo
    @diogos_cart = @diogo.carts.create!(created_at: Time.current.yesterday)
    @item1       = @diogos_cart.items.create! product: @book1, quantity: 10
    @item2       = @diogos_cart.items.create! product: @book2, quantity: 1

    # @hen Diogo backs
    @item2.quantity += 2
    @item2.save!

    @joaos_cart  = @joao.carts.create!
    @joaos_cart.items.create! product: @book2, quantity: 2
  end

  it "What is the total that Diogo will have to pay?" do
    expect(@diogos_cart.total).to eq((24.99 * 10) + (9001 * 3))
  end

  it "What products and respective quantities has Diogo in his cart?" do
    result = @diogos_cart.items.map {|i| [i.product, i.quantity] }
    expect(result).to eq [[@book1, 10], [@book2, 3]]
  end

  it "How many products are overall in your Cart system?" do
    result = CartItem.sum(:quantity)
    expect(result).to eq 15
  end

  it "What is the total amount of money that you have pending on your system?" do
    result   = CartItem.joins(:cart).where('carts.status' => 'pending').sum(:total_price)
    expected = (24.99 * 10) + (9001.0 * 5)
    expect(result).to eq expected
  end
end
