require 'rails_helper'

RSpec.describe "cart/index.html.erb", type: :view do
  it "displays a form in order the client can update it" do
    p1 = Product.create! name: 'My favorite book', price: 39
    u = User.create! name: 'João'
    c = u.carts.create!
    c.items.create! product: p1
    assign(:cart, c)
    render
    expect(rendered).to include('action="/cart/update"')
  end

  it "displays the cart items" do
    p1 = Product.create! name: 'My favorite book', price: 39
    p2 = Product.create! name: 'My almost favorite book', price: 29
    u = User.create! name: 'João'
    c = u.carts.create!
    c.items.create! product: p1
    assign(:cart, c)
    render
    expect(rendered).to include(p1.name)
    expect(rendered).not_to include(p2.name)
  end

  it "displays the quantity fields" do
    p1 = Product.create! name: 'My favorite book', price: 39
    p2 = Product.create! name: 'My almost favorite book', price: 29
    u = User.create! name: 'João'
    c = u.carts.create!
    c.items.create! product: p1
    assign(:cart, c)
    render
    expect(rendered).to include('name="cart[items_attributes][0][quantity]"')
  end

  it "displays the Update button" do
    p1 = Product.create! name: 'My favorite book', price: 39
    p2 = Product.create! name: 'My almost favorite book', price: 29
    u = User.create! name: 'João'
    c = u.carts.create!
    c.items.create! product: p1
    assign(:cart, c)
    render
    expect(rendered).to include(submit_tag('Update and continue buying'))
  end

  it "displays the Checkout button" do
    p1 = Product.create! name: 'My favorite book', price: 39
    p2 = Product.create! name: 'My almost favorite book', price: 29
    u = User.create! name: 'João'
    c = u.carts.create!
    c.items.create! product: p1
    assign(:cart, c)
    render
    expect(rendered).to include(submit_tag('Checkout'))
  end
end
