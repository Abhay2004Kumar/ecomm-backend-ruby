class Product < ApplicationRecord
  has_one_attached :image

  has_many :cart_items
  has_many :order_items

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
end
