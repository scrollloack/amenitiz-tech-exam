module ProductsHelper
  module Prices
    class Strawberry < Base
      def total_price(item)
        price = item["quantity"] > 2 ? 4.50 : item["price"].to_f
        (price * item["quantity"]).round(2)
      end
    end
  end
end
