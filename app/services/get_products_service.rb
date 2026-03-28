class GetProductsService
  def self.call
    Product.all
  end
end
