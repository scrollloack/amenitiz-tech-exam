require "rails_helper"

RSpec.describe ProductsHelper::Prices::Strawberry, type: :helper do
  subject(:base_subject) { described_class.new }

  describe "#total_price" do
    context "when quantity is less than or equal to 2" do
      let(:item) { { "quantity" => 2, "price" => 5.00 } }

      it "uses the original price and calculates the total prices" do
        expect(base_subject.total_price(item)).to eq(10.00)
      end
    end

    context "when quantity is greater than 2" do
      let(:item) { { "quantity" => 3, "price" => 5.00 } }

      it "uses discounted price and calculates the total price" do
        expect(base_subject.total_price(item)).to eq(13.50)
      end
    end
  end
end
