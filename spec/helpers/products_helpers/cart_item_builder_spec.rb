require "rails_helper"

RSpec.describe ProductsHelper::CartItemBuilder, type: :helper do
  describe "#call" do
    let(:product) { build_stubbed(:product, product_code: product_code, name: "Green Tea", price: 3.11) }
    let(:product_code) { "GR1" }

    subject { described_class.new(current_cart, product_code, product, 1) }

    context "when a product exists in the current cart" do
      let(:current_cart) { { product_code => existing_item } }

      let(:existing_item) do
        {
          "product_code" => product_code,
          "name" => "Green Tea",
          "price" => 3.11,
          "quantity" => 2
        }
      end

      it "returns the existing item from the cart" do
        expect(subject.call).to eq(existing_item)
      end
    end

    context "when a product does not exists in the current cart" do
      let(:current_cart) { {} }

      it "returns a new item hash with default quantity 0" do
        expect(subject.call).to eq({
          "product_code" => product.product_code,
          "name" => product.name,
          "price" => product.price,
          "quantity" => 0
        })
      end
    end
  end
end
