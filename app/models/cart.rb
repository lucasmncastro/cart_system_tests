class Cart < ApplicationRecord
  belongs_to :user
  enum status: %w(pending expired finished)
end
