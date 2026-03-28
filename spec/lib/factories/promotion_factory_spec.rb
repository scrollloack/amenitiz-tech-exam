require "rails_helper"

RSpec.describe Factories::PromotionFactory, type: :factory do
  describe ".build" do
    subject { described_class.build(code) }

    context "when product_code is GR1" do
      let(:code) { "GR1" }
      it "returns a GreenTea class" do
        expect(subject).to be_a(ProductsHelper::Prices::GreenTea)
      end
    end

    context "when product_code is SR1" do
      let(:code) { "SR1" }

      it "returns a Strawberry class" do
        expect(subject).to be_a(ProductsHelper::Prices::Strawberry)
      end
    end

    context "when product_code is CF1" do
      let(:code) { "CF1" }

      it "returns a Coffee class" do
        expect(subject).to be_a(ProductsHelper::Prices::Coffee)
      end
    end

    context "when product_code is unknown" do
      let(:code) { "UNKNOWN" }

      it "returns a Base class" do
        expect(subject).to be_a(ProductsHelper::Prices::Base)
      end
    end
  end
end
