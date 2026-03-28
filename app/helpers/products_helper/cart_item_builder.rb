module ProductsHelper
  class CartItemBuilder
    def initialize(current_cart, product_code, product, quantity)
      @current_cart = current_cart
      @product_code = product_code
      @product = product
    end

    def call
      @current_cart[@product_code] || {
        "product_code" => @product.product_code,
        "name" => @product.name,
        "price" => @product.price,
        "quantity" => 0
      }
    end
  end
end
