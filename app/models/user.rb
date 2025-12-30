class User < ApplicationRecord
  has_secure_password

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

  after_create :create_cart

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }

  private

  def create_cart
    Cart.create(user: self)
  end
end
