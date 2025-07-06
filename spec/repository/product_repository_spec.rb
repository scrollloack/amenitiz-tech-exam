require "rails_helper"

RSpec.describe ProductRepository do
  subject { described_class }

  describe ".model" do
    it "returns the Product model" do
      expect(subject.model).to eq(Product)
    end
  end

  describe ".find_by" do
    let(:data) { { product_code: "GR1" } }
    let(:product) { build_stubbed(:product, data) }

    before do
      allow(Product).to receive(:find_by).and_return(product)
    end

    it "finds the product with correct arguments and returns the product" do
      expect(Product).to receive(:find_by).with(data)
      expect(subject.find_by(data)).to eq(product)
    end
  end
end
