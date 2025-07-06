module ProductsHelper
  module Prices
    class Coffee < Base
      def total_price(item)
        price = item["quantity"] > 2 ? (item["price"].to_f * (2.0/3.0)).round(2) : item["price"].to_f
        (price * item["quantity"]).round(2)
      end
    end
  end
end
