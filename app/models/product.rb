class Product < ApplicationRecord
  has_one_attached :image

  has_many :cart_items
  has_many :order_items

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  # Check if product is in stock
  def in_stock?(quantity = 1)
    stock >= quantity
  end
end
