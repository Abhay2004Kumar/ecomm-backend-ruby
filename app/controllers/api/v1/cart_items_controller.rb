class Api::V1::CartItemsController < ApplicationController
      # def create
      #   cart = Cart.find_by(user_id: params[:user_id])
      #   product = Product.find(params[:product_id])

      #   cart_item = cart.cart_items.find_or_initialize_by(product: product)
      #   cart_item.quantity = (cart_item.quantity || 0) + params[:quantity].to_i

      #   cart_item.save

      #   render json: cart_item, status: :created
      # end

      # def update
      #   cart_item = CartItem.find(params[:id])

      #   if cart_item.update(quantity: params[:quantity])
      #     render json: cart_item
      #   else
      #     render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
      #   end
      # end

      # def destroy
      #   cart_item = CartItem.find(params[:id])
      #   cart_item.destroy

      #   render json: { message: "Item removed from cart" }
      # end

  include AuthenticateUser

  def create
    cart = @current_user.cart
    product = Product.find(params[:product_id])

    cart_item = cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = (cart_item.quantity || 0) + params[:quantity].to_i
    cart_item.save

    render json: cart_item, status: :created
  end
    
end
