class Api::V1::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
        payload = request.body.read
        sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
        secret = ENV["STRIPE_WEBHOOK_SECRET"]

        event = nil

        begin
          event = Stripe::Webhook.construct_event(
            payload, sig_header, secret
          )
        rescue JSON::ParserError, Stripe::SignatureVerificationError
          return head :bad_request
        end

        handle_event(event)
        render json: { status: "success" }
  end

  private

  def handle_event(event)
        case event.type
        when "payment_intent.succeeded"
          handle_payment_success(event.data.object)
        when "payment_intent.payment_failed"
          handle_payment_failure(event.data.object)
        end
  end

  def handle_payment_success(intent)
        user = User.find(intent.metadata.user_id)
        cart = user.cart

        order = user.orders.create!(
          status: "paid",
          total_amount: intent.amount / 100.0
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
        
        Payment.create!(
          user: user,
          order: order,
          stripe_payment_intent_id: intent.id,
          amount: intent.amount / 100.0,
          status: "success"
        )

        cart.cart_items.destroy_all

        
  end

  def handle_payment_failure(intent)
        Payment.create!(
          stripe_payment_intent_id: intent.id,
          amount: intent.amount / 100.0,
          status: "failed"
        )
  end

end
