class Cart < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'CartItem'
  accepts_nested_attributes_for :items

  enum status: %w(pending expired finished)
end
