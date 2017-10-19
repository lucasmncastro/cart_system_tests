require 'rails_helper'

RSpec.describe User, type: :model do
  it "should be not admin by default" do
    user = User.new
    expect(user.admin).to be false
  end

  it "should have a name" do
    user = User.new
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include("can't be blank")
  end
end
