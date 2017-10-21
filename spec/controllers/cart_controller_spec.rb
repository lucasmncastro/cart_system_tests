require 'rails_helper'

RSpec.describe CartController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      u = User.create! name: 'João'
      get :index, session: { user_id: u.id }
      expect(response).to have_http_status(:success)
    end

    it "redirects to the (fake) login if the user is logged out" do
      get :index, session: { user_id: nil }
      expect(response).to redirect_to("/login")
    end

    it "creates a cart if there is no pending cart" do
      u  = User.create! name: 'João'
      c1 = Cart.create! user: u, status: :finished
      get :index, session: { user_id: u.id }
      expect(assigns(:cart)).to_not eq(c1)
      expect(assigns(:cart).status).to eq('pending')
    end

    it "uses the pending cart if there is one" do
      u  = User.create! name: 'João'
      c1 = Cart.create! user: u, status: :pending
      c2 = Cart.create! user: u, status: :finished
      get :index, session: { user_id: u.id }
      expect(assigns(:cart)).to eq(c1)
    end

    it "expires the cart is already passed more than 2 days" do
      u = User.create! name: 'João'
      c = Cart.create! user: u, status: :pending, created_at: Date.today - 2.days - 1.minute
      get :index, session: { user_id: u.id }
      expect(assigns(:cart)).to be_present
      expect(assigns(:cart)).to_not eq(c)
    end

  end

  describe "GET #add" do
    it "redirects to the (fake) login if the user is logged out" do
      p = Product.create! name: 'Book', price: 10
      get :add, params: { product_id: p }, session: { user_id: nil }
      expect(response).to redirect_to("/login")
    end

    it "creates a cart if there is no pending open cart"
    it "uses the pending cart if there is one"

    it "expires the cart is already passed more than 2 days" do
      u = User.create! name: 'João'
      c = Cart.create! user: u, status: :pending, created_at: Date.today - 2.days - 1.minute
      p = Product.create! name: 'Book', price: 10
      get :add, params: { product_id: p }, session: { user_id: u.id }
      expect(assigns(:cart)).to be_present
      expect(assigns(:cart)).to_not eq(c)
    end

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
      expect(assigns(:cart).items.first.quantity).to eq(1)

      get :add, params: { product_id: p }, session: { user_id: u.id }
      assigns(:cart).reload
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

    describe "with 'save' submit" do
      it "redirect after update successfully" do
        p = Product.create! name: 'Book', price: 10
        u = User.create! name: 'João'
        c = Cart.create! user: u
        i = c.items.create! product: p, quantity: 5

        post_params = { cart: { items_attributes: { '0' => { id: i.id, quantity: 3 } } } }
        patch :update, params: post_params, session: { user_id: u.id }

        expect(response).to have_http_status(:redirect)
      end

      it "updates the cart items when the user change the quantity of an item" do
        p = Product.create! name: 'Book', price: 10
        u = User.create! name: 'João'
        c = Cart.create! user: u
        i = c.items.create! product: p, quantity: 5

        post_params = { cart: { items_attributes: { '0' => { id: i.id, quantity: 3 } } } }
        patch :update, params: post_params, session: { user_id: u.id }
        i.reload
        expect(i.quantity).to eq(3)
      end

      it "updates the cart items when the user remove an item" do
        p = Product.create! name: 'Book', price: 10
        u = User.create! name: 'João'
        c = Cart.create! user: u
        i = c.items.create! product: p, quantity: 5

        post_params = { cart: { items_attributes: { '0' => { id: i.id, quantity: 3, _destroy: true } } } }
        patch :update, params: post_params, session: { user_id: u.id }
        c.reload
        expect(c.items.size).to eq(0)
      end

      it "redirects to the store"
      it "shows a flash message"
    end

    describe "with 'checkout' submit" do
      it "changes the cart status to finished" do
        p = Product.create! name: 'Book', price: 10
        u = User.create! name: 'João'
        c = Cart.create! user: u
        i = c.items.create! product: p, quantity: 5

        post_params = { commit: 'Checkout', cart: { items_attributes: { '0' => { id: i.id, quantity: 4 } } } }
        patch :update, params: post_params, session: { user_id: u.id }

        c.reload
        expect(c.status).to eq('finished')
      end

      it "shows the super-charged fantabolastic thanks!" do
        p = Product.create! name: 'Book', price: 10
        u = User.create! name: 'João'
        c = Cart.create! user: u
        i = c.items.create! product: p, quantity: 5

        post_params = { commit: 'Checkout', cart: { items_attributes: { '0' => { id: i.id, quantity: 4 } } } }
        patch :update, params: post_params, session: { user_id: u.id }

        expect(response).to redirect_to(:thanks)
      end
    end
  end

  describe "when the prices have changed" do
    before(:each) do
      @user = User.create! name: 'João'
      p = Product.create! name: 'My favorite book', price: 39
      c = @user.carts.create!
      c.items.create! product: p
      p.update price: 49
    end

    describe "GET #outdated" do
      it "should load the cart to show the differences" do
        get :outdated, session: { user_id: @user.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #accept_changes" do
      it "should update the items with prices" do
        get :accept_changes, session: { user_id: @user.id }
        expect(CartItem.first.unit_price).to eq(49)
      end
    end

    describe "GET #reject_changes" do
      it "should remove the items with prices changes from the cart" do
        get :reject_changes, session: { user_id: @user.id }
        expect(CartItem.count).to eq(0)
      end
    end
  end

end
