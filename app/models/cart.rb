class Cart < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'CartItem'

  enum status: %w(pending expired finished)
end
