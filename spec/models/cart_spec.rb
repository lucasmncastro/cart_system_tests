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

  describe "#outdated?" do
    it "should return true if some item price have changed" do
      p = Product.create! name: 'Book', price: 10
      u = User.create! name: 'João'
      c = Cart.create! user: u
      i = c.items.create! product: p, quantity: 5

      expect(i.unit_price).to eq(p.price)

      p.price = 9.90
      expect(c).to be_outdated
    end

    it "should return false if ome item price have not changed" do
      p = Product.create! name: 'Book', price: 10
      u = User.create! name: 'João'
      c = Cart.create! user: u
      i = c.items.create! product: p, quantity: 5

      expect(i.unit_price).to eq(p.price)

      expect(c).to_not be_outdated
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

  describe "#accept_changes!" do

    it "should update the items prices" do
      p = Product.create! name: 'My favorite book', price: 39
      u = User.create! name: 'João'
      c = u.carts.create!
      c.items.create! product: p
      p.update price: 49

      c.accept_changes!

      expect(c.items.first.unit_price).to eq(49)
    end
  end

  describe "#reject_changes!" do
    it "should remove the items with outdated prices" do
      p1 = Product.create! name: 'My favorite book', price: 39
      p2 = Product.create! name: 'My almost favorite book', price: 29
      u  = User.create! name: 'João'
      c  = u.carts.create!
      i1 = c.items.create! product: p1
      i2 = c.items.create! product: p2
      p1.update! price: 49

      c.reject_changes!
      c.items.reload

      expect(c.items.to_a).to eq([i2])
    end
  end

end
