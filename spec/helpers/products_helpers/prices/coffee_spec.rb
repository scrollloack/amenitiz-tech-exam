require "rails_helper"

RSpec.describe ProductsHelper::Prices::Coffee, type: :helper do
  subject(:base_subject) { described_class.new }

  describe "#total_price" do
    context "when quantity is less than or equal to 2" do
      let(:item) { { "quantity" => 2, "price" => 11.23 } }

      it "uses the full price without discount and calculates the total price" do
        expect(base_subject.total_price(item)).to eq((11.23 * 2).round(2))
      end
    end

    context "when quantity is greater than 2" do
      let(:item) { { "quantity" => 3, "price" => 11.23 } }

      it "applies the 2/3 discount and calculates the total price" do
        discounted_price = (11.23 * (2.0 / 3.0)).round(2)
        expect(base_subject.total_price(item)).to eq((discounted_price * 3).round(2))
      end
    end
  end
end
