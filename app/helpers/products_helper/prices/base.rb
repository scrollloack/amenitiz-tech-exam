module ProductsHelper
  module Prices
    class Base
      def effective_quantity(item, quantity)
        item["quantity"].to_i + quantity
      end

      def total_price(item)
        (item["quantity"] * item["price"].to_f).round(2)
      end
    end
  end
end
