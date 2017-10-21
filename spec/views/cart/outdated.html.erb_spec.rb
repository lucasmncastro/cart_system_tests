require 'rails_helper'

RSpec.describe "cart/outdated.html.erb", type: :view do
  before(:each) do
    p = Product.create! name: 'My favorite book', price: 39
    u = User.create! name: 'João'
    c = u.carts.create!
    c.items.create! product: p
    p.update price: 49

    assign(:cart, c)
    render
  end

  it "displays a friendly message" do
    expect(rendered).to include('We are so sorry, but we changed some prices!')
  end

  it "shows the items with their price changed" do
    expect(rendered).to include('My favorite book')
    expect(rendered).to include('Before: $39.00')
    expect(rendered).to include('Today: $49.00')
  end

  it "shows a link to the user confirm the changes" do
    expect(rendered).to include(link_to("Accept", accept_changes_cart_path))
  end

  it "shows a link to the user reject the changes" do
    expect(rendered).to include(link_to("Reject", reject_changes_cart_path))
  end
end
