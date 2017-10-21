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

  describe "#mark_as_expired!" do
    it "should update its status to 'expired'" do
      user = User.create!(name: 'João')
      cart = Cart.create! user: user

      expect(cart.status).to eq('pending')
      cart.mark_as_expired!
      expect(cart.status).to eq('expired')
    end
  end


  describe "#verify_expired?" do
    it "should return false if it was created last 24h" do
      user = User.create!(name: 'João')
      cart = Cart.create! user: user, created_at: (Time.current)
      expect(cart).to_not be_verify_expired
    end

    it "should return false if it was created last 48h" do
      user = User.create!(name: 'João')
      cart = Cart.create! user: user, created_at: (Time.current - 2.days + 1.second)
      expect(cart).to_not be_verify_expired
    end

    it "should return true if it was created more then two days" do
      user = User.create!(name: 'João')
      cart = Cart.create! user: user, created_at: (Time.current - 3.days)
      expect(cart).to be_verify_expired
    end
  end

end
