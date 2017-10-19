require 'rails_helper'

RSpec.describe StoreController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "load all the products" do
      products = [Product.create!(name: 'Book 1', price: 10), Product.create!(name: 'Book 2', price: 20)]
      get :index
      expect(assigns(:products)).to match_array(products)
    end
  end

  describe "GET #product" do
    it "returns http success" do
      product = Product.create! name: 'My Book', price: 19.10
      get :product, params: {id: product.id}
      expect(response).to have_http_status(:success)
    end

    it "load the product with the given :id" do
      product = Product.create! name: 'My Book', price: 19.10
      get :product, params: {id: product.id}
      expect(assigns(:product)).to eq(product)
    end
  end

end
