class Api::V1::CartsController < ApplicationController
   def show
        cart = Cart.find_by(user_id: params[:user_id])

        render json: cart.as_json(
          include: {
            cart_items: {
              include: :product
            }
          }
        )
      end
end
