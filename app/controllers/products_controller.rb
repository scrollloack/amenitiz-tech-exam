class ProductsController < ApplicationController
  rate_limit to: 4, within: 1.minute,
  by: -> { request.remote_ip },
  with: -> { redirect_to "/not_found" },
  only: [ :index, :add_to_cart ]

  def index
    @products = GetProductsService.call

    render "checkout_page/index", status: 200
  end

  def add_to_cart
    puts "Hello world!=====#{params[:id]}"
    render plain: "OK!"
  end
end
