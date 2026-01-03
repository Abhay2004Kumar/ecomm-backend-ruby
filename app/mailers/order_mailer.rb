class OrderMailer < ApplicationMailer

  def order_confirmation(order)
    @order = order
    @user = order.user

    mail(
      to: @user.email,
      subject: "Order Confirmation ##{@order.id}"
    )
  end
end
