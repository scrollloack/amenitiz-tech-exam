require "rails_helper"

RSpec.describe ProductsHelper::Prices::GreenTea, type: :helper do
  subject(:base_subject) { described_class.new }

  describe "#effective_quantity" do
    let(:item) { { "quantity" => existing_quantity } }

    context "when total quantity is 1" do
      let(:existing_quantity) { 0 }

      it "adds 1 extra quantity" do
        expect(base_subject.effective_quantity(item, 1)).to eq(2)
      end
    end

    context "when total quantity is more than 1" do
      let(:existing_quantity) { 1 }

      it "returns the summed quantity" do
        expect(base_subject.effective_quantity(item, 1)).to eq(2)
      end
    end
  end

  describe "#total_price" do
    let(:item) { { "quantity" => quantity, "price" => price } }
    let(:price) { 3.11 }

    context "when quantity is less than or equal to 2" do
      let(:quantity) { 2 }

      it "calculates for only 1 item and returns the total price" do
        expect(base_subject.total_price(item)).to eq(3.11)
      end
    end

    context "when quantity is 4" do
      let(:quantity) { 4 }

      it "calculates for only 3 items and returns the total price" do
        expect(base_subject.total_price(item)).to eq(9.33)
      end
    end
  end
end
