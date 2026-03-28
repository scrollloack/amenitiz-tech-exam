class ProductRepository
  def self.model
    Product
  end

  def self.find_by(data)
    model.find_by(data)
  end
end
