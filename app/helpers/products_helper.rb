module ProductsHelper
  class PriceCalculator
    def initialize(data)
      @data = data
    end

    def call
      case @data["product_code"]
      when "GR1"
        apply_buy_one_get_one
      when "SR1"
        apply_strawberry_discount
      when "CF1"
        apply_coffee_discount
      else
        standard_price
      end
    end

    private

      def apply_buy_one_get_one
        quantity = @data["quantity"].to_i - 1
        (quantity.to_i * @data["price"].to_f).round(2)
      end

      def apply_strawberry_discount
        price = @data["quantity"] > 2 ? 4.50 : @data["price"].to_f
        (price * @data["quantity"]).round(2)
      end

      def apply_coffee_discount
        price = @data["quantity"] > 2 ? (@data["price"].to_f * (2.0/3.0)).round(2) : @data["price"].to_f
        (price * @data["quantity"]).round(2)
      end

      def standard_price
        (@data["quantity"] * @data["price"].to_f).round(2)
      end
  end
end
