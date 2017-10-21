require 'rails_helper'

RSpec.describe "cart/thanks.html.erb", type: :view do
  it "shows the super-charged fantabolastic thanks!" do
    render
    expect(rendered).to include('thanks!')
  end
end
