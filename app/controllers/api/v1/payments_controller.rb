class Api::V1::PaymentsController < ApplicationController
  include AuthenticateUser

      def create
        cart = @current_user.cart

        if cart.cart_items.empty?
          return render json: { error: "Cart is empty" }, status: :unprocessable_entity
        end

        amount = calculate_amount(cart)

        intent = Stripe::PaymentIntent.create(
          amount: (amount * 100).to_i, # Stripe uses paise
          currency: "inr",
          metadata: {
            user_id: @current_user.id
          }
        )

        render json: {
          client_secret: intent.client_secret,
          amount: amount
        }
      end

      private

      def calculate_amount(cart)
        cart.cart_items.sum do |item|
          item.quantity * item.product.price
        end
      end
end
