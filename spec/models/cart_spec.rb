require 'rails_helper'

RSpec.describe Cart, type: :model do

  it "should belongs to an user" do
    cart = Cart.new
    expect(cart).not_to be_valid
    expect(cart.errors[:user]).to include("must exist")
  end

  it "should be pending by default" do
    cart = Cart.new
    expect(cart.status).to eq('pending')
  end

end
