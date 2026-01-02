class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :order

  validates :status, presence: true
end
