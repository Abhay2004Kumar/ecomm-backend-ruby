class Api::V1::OrdersController < ApplicationController
      # def create
      #   user = User.find(params[:user_id])
      #   cart = user.cart

      #   order = user.orders.create!(
      #     status: "placed",
      #     total_amount: 0
      #   )

      #   total = 0

      #   cart.cart_items.each do |item|
      #     order.order_items.create!(
      #       product: item.product,
      #       quantity: item.quantity,
      #       price: item.product.price
      #     )

      #     total += item.quantity * item.product.price
      #   end

      #   order.update(total_amount: total)
      #   cart.cart_items.destroy_all

      #   render json: order, status: :created
      # end

      # def index
      #   user = User.find(params[:user_id])
      #   render json: user.orders
      # end

  include AuthenticateUser

  def create
    cart = @current_user.cart

    # Validate stock availability
    cart.cart_items.each do |item|
      if item.product.stock < item.quantity
        return render json: { 
          error: "Insufficient stock for #{item.product.name}. Available: #{item.product.stock}" 
        }, status: :unprocessable_entity
      end
    end

    order = @current_user.orders.create!(
      status: "paid",
      total_amount: cart_total(cart)
    )

    # Create order items and update stock
    cart.cart_items.each do |item|
      order.order_items.create!(
        product: item.product,
        quantity: item.quantity,
        price: item.product.price
      )
      
      # Decrement product stock
      item.product.decrement!(:stock, item.quantity)
    end

    cart.cart_items.destroy_all
    
    # Send order confirmation email
    OrderMailer.order_confirmation(order).deliver_later
    
    render json: order, status: :created
  end

  def index
    render json: @current_user.orders, status: :ok
  end

  private
  def cart_total(cart)
    cart.cart_items.sum do |item|
      item.quantity * item.product.price
    end
  end

end
