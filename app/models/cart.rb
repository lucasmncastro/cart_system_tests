class Cart < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'CartItem'
  accepts_nested_attributes_for :items, allow_destroy: true

  enum status: %w(pending expired finished)
end
