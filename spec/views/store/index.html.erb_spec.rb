require 'rails_helper'

RSpec.describe "store/index.html.erb", type: :view do
  it "display all the products" do
    products = [Product.create!(name: 'Book 1', price: 10), Product.create!(name: 'Book 2', price: 20)]
    assign(:products, products)
    render
    expect(rendered).to include("Book 1") 
    expect(rendered).to include("Book 2") 
  end
end
