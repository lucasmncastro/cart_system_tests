require 'rails_helper'

RSpec.describe CartController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "redirects to the (fake) login if the user is logged out"
    it "creates a cart if there is no pending cart"
    it "uses the pending cart if there is one"
  end

  describe "GET #add" do
    it "redirects to the (fake) login if the user is logged out"
    it "creates a cart if there is no pending open cart"
    it "uses the pending cart if there is one"

    it "adds a new product to the cart" do
      u = User.create! name: 'João'
      p = Product.create! name: 'Book', price: 10
      get :add, params: { product_id: p }, session: { user_id: u.id }
      expect(assigns(:cart).items.size).to eq(1)
      expect(assigns(:cart).items.first.product).to eq(p)
      expect(assigns(:cart).items.first.quantity).to eq(1)
    end

    it "increments the quantity of a product already added" do
      u = User.create! name: 'João'
      p = Product.create! name: 'Book', price: 10
      get :add, params: { product_id: p }, session: { user_id: u.id }
      get :add, params: { product_id: p }, session: { user_id: u.id }
      expect(assigns(:cart).items.first.quantity).to eq(2)
    end

    it "redirects to the store" do
      u = User.create! name: 'João'
      p = Product.create! name: 'Book', price: 10
      get :add, params: { product_id: p }, session: { user_id: u.id }
      expect(response).to have_http_status(:redirect)
    end

    it "shows a flash message" do
      u = User.create! name: 'João'
      p = Product.create! name: 'Book', price: 10
      get :add, params: { product_id: p }, session: { user_id: u.id }
      expect(flash[:notice]).to match(/Item successful added/)
    end
  end

  describe "PATCH #update" do
    it "returns http success" do
      patch :update
      expect(response).to have_http_status(:success)
    end

    it "updates the cart items when the user change the quantity of an item"
    it "updates the cart items when the user remove an item"

    it "redirects to the store"
    it "shows a flash message"
  end

  describe "PATCH #checkout" do
    it "returns http success" do
      patch :checkout
      expect(response).to have_http_status(:success)
    end

    it "changes the cart status to finished"
    it "shows the super-charged fantabolastic thanks!"
  end

end
