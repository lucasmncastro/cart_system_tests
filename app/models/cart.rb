class Cart < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'CartItem'
  accepts_nested_attributes_for :items, allow_destroy: true

  enum status: %w(pending expired finished)

  def verify_expired?
    return false if created_at.blank?

    created_at < Time.current - 2.days
  end

  def mark_as_expired!
    update! status: 'expired'
  end
end
