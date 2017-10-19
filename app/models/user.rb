class User < ApplicationRecord
  has_many :carts
  validates :name, presence: true
end
