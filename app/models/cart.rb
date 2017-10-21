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

  def outdated?
    old_unit_sum     = items.map(&:unit_price).sum
    current_unit_sum = items.map { |i| i.product.price }.sum
    old_unit_sum != current_unit_sum
  end

  def accept_changes! 
    items.each do |i|
      if i.product.price != i.unit_price
        i.save!
      end
    end
  end

  def reject_changes!
    items.each do |i|
      if i.product.price != i.unit_price
        i.delete
      end
    end
  end
end
