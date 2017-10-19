require 'rails_helper'

describe 'Routes Spec', type: :routing do
  it '/ should route to store#index' do
    expect(get: '/').to route_to('store#index')
  end

  it '/product/:id should route to store#product' do
    expect(get: '/product/1').to route_to('store#product', id: '1')
  end
end
