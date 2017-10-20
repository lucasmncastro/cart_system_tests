require 'rails_helper'

RSpec.describe "sessions/new.html.erb", type: :view do
  it "have a form with a field to identify the user" do
    render
    expect(rendered).to include("Enter your name")
    expect(rendered).to include(text_field(:user, :name))
  end

  it "should display message when user is invalid" do
    assign(:error, 'User not found')
    render
    expect(rendered).to include("User not found")
  end
end
