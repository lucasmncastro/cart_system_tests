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
    it "returns http success" do
      p = Product.create! name: 'Book', price: 10
      get :add, params: { product_id: p }
      expect(response).to have_http_status(:success)
    end

    it "redirects to the (fake) login if the user is logged out"
    it "creates a cart if there is no pending open cart"
    it "uses the pending cart if there is one"

    it "adds a new product to the cart"
    it "redirects to the store"
    it "shows a flash message"
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
