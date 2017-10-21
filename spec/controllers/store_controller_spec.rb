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

    describe "when the user is logged in" do
      it "should assign @current_user" do
        u = User.create! name: "Diogo"
        get :index, session: { user_id: u.id }
        expect(assigns(:current_user)).to eq(u)
      end

      it "it should redirect the user if any product's price in his pending cart has changed" do
        u = User.create! name: 'Diogo'
        c = Cart.create! user: u, status: :pending
        p = Product.create! name: 'Book', price: 10
        i = c.items.create! product: p, quantity: 2  
        expect(i.unit_price).to eq(p.price)

        p.update! price: 12
        get :index, session: { user_id: u.id }
        expect(response).to redirect_to(outdated_cart_path)
      end
    end
  end

end
