class AddToCartService
  def initialize(data, user_id)
    @data = data
    @key = "cart:#{user_id}"
  end

  def call
    process
  end

  private

    def process
      item = item_builder

      item["quantity"] = promotion.effective_quantity(item, @data[:quantity])
      item["total_price"] = promotion.total_price(item)

      current_cart[@data[:product_code].to_s] = item

      redis_connection.save(current_cart.to_json)
      redis_connection.expire

      item
    end

    def current_cart
      @current_cart ||= initial_cart.is_a?(String) ? JSON.parse(initial_cart) : {}
    end

    def initial_cart
      @initial_cart ||= redis_connection.fetch
    end

    def item_builder
      item_builder ||= ProductsHelper::CartItemBuilder.new(
        current_cart,
        @data[:product_code].to_s,
        product,
        @data[:quantity]
      ).call
    end

    def product
      @product ||= ProductRepository.find_by({ product_code: @data[:product_code] })
    end

    def promotion
      @promotion ||= ::Factories::PromotionFactory.build(@data[:product_code].to_s)
    end

    def redis_connection
      @redis_connection ||= RedisRepository.new(@key)
    end
end
