require "rails_helper"

RSpec.describe ProductsHelper::Prices::Base do
  let(:item) { { "quantity" => 2, "price" => 3.50 } }

  subject { described_class.new }

  describe "#effective_quantity" do
    it "adds the item's quantity to the given quantity" do
      expect(subject.effective_quantity(item, 3)).to eq(5)
    end
  end

  describe "#total_price" do
    it "returns the total price based on quantity and price" do
      expect(subject.total_price(item)).to eq(7.00)
    end
  end
end
