require 'rails_helper'

describe 'Routes Spec', type: :routing do
  it '/ should route to store#index' do
    expect(get: '/').to route_to('store#index')
  end
end
