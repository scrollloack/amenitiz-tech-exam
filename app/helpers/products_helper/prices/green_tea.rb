module ProductsHelper
  module Prices
    class GreenTea < Base
      def effective_quantity(item, quantity)
        total_quantity = item["quantity"].to_i + quantity

        total_quantity == 1 ? total_quantity + 1 : total_quantity
      end

      def total_price(item)
        quantity = item["quantity"].to_i - 1
        (quantity.to_i * item["price"].to_f).round(2)
      end
    end
  end
end
