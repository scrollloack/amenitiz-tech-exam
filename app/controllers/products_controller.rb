class ProductsController < ApplicationController
  unless Rails.env.test?
    rate_limit to: 4, within: 1.minute,
    by: -> { request.remote_ip },
    with: -> { redirect_to "/not_found" },
    only: [ :index, :add_to_cart, :clear_cart ]
  end

  def index
    @products = GetProductsService.call

    render "checkout_page/index", status: 200
  end

  def add_to_cart
    user_id = session.id
    permitted_data = params.require(:data).permit(:product_code, :quantity)

    result = AddToCartService.new(permitted_data, user_id).call

    render json: result
  end

  def clear_cart
    user_id = session.id
    ClearCartService.new(user_id).call

    head :no_content
  end
end
