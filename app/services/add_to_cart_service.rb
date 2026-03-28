class AddToCartService
  def initialize(data, user_id)
    @redis = $redis
    @data = data
    @key = "cart:#{user_id}"
  end

  def call
    process
  end

  private

    def process
      init_cart = @redis.get(@key)
      current_cart = init_cart.is_a?(String) ? JSON.parse(init_cart) : {}

      item = current_cart[@data[:product_code].to_s] || {
        "product_code" => product.product_code,
        "name" => product.name,
        "price" => product.price,
        "quantity" => 0
      }

      total_quantity = item["quantity"].to_i + @data[:quantity]
      effective_quantity = total_quantity == 1 ?
        apply_quantity_promotion(product.product_code, total_quantity) :
        total_quantity
      item["quantity"] = effective_quantity
      item["total_price"] = ProductsHelper::PriceCalculator.new(item).call

      current_cart[@data[:product_code].to_s] = item

      @redis.set(@key, current_cart.to_json)
      @redis.expire(@key, 2 * 60 * 60)

      item
    end

    def product
      @product ||= Product.find_by(product_code: @data[:product_code])
    end

    def apply_quantity_promotion(code, quantity)
      case code
      when "GR1"
        quantity + 1
      else
        quantity
      end
    end
end
