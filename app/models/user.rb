class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

  after_create :create_cart

  validates :email, presence: true, uniqueness: true

  private

  def create_cart
    Cart.create(user: self)
  end
end
