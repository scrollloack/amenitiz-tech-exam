module Factories
  class PromotionFactory
    def self.build(product_code)
      case product_code
      when "GR1"
        ProductsHelper::Prices::GreenTea.new
      when "SR1"
        ProductsHelper::Prices::Strawberry.new
      when "CF1"
        ProductsHelper::Prices::Coffee.new
      else
        ProductsHelper::Prices::Base.new
      end
    end
  end
end
