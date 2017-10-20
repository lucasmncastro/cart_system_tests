require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    describe "with valid user" do
      it "returns http success" do
        u = User.create! name: 'João'
        post :create, params: { user: { name: u.name } }
        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to eq(u.id)
      end
    end

    describe "with invalid user" do
      it "returns http success" do
        u = User.create! name: 'João'
        post :create, params: { user: { name: 'Joaquim' } }
        expect(response).to have_http_status(:success)
        expect(assigns(:error)).to eq('User not found')
      end
    end
  end

  describe "GET #destroy" do
    it "should clear the user in the session" do
      u = User.create! name: 'João'
      get :destroy, session: { user_id: u.id }
      expect(session[:user_id]).to be_nil
    end

    it "should redirect to root page" do
      u = User.create! name: 'João'
      get :destroy, session: { user_id: u.id }
      expect(response).to redirect_to(root_path)
    end
  end

end
