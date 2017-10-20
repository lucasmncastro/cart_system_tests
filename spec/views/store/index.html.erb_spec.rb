require 'rails_helper'

RSpec.describe "store/index.html.erb", type: :view do
  it "display all the products" do
    products = [Product.create!(name: 'Book 1', price: 10), Product.create!(name: 'Book 2', price: 20)]
    assign(:products, products)
    render
    expect(rendered).to include("Book 1") 
    expect(rendered).to include("Book 2") 
  end

  it "display 'Add to cart' links" do
    products = [Product.create!(name: 'Book 1', price: 10), Product.create!(name: 'Book 2', price: 20)]
    p1, p2   = products
    assign(:products, products)
    render
    expect(rendered).to include(link_to("Add to cart", add_cart_path(product_id: p1))) 
    expect(rendered).to include(link_to("Add to cart", add_cart_path(product_id: p2))) 
  end

  describe "when the user is logged in" do
    it "should display his name" do
      products = [Product.create!(name: 'Book 1', price: 10), Product.create!(name: 'Book 2', price: 20)]
      assign(:products, products)
      user = User.create! name: 'João'
      assign(:current_user, user)
      render
      expect(rendered).to include("Welcome, João!") 
    end

    it "should display the logout link" do
      products = [Product.create!(name: 'Book 1', price: 10), Product.create!(name: 'Book 2', price: 20)]
      assign(:products, products)
      user = User.create! name: 'João'
      assign(:current_user, user)
      render
      expect(rendered).to include(link_to "Log out", logout_path) 
    end
  end
end
