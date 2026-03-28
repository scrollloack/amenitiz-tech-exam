require "rails_helper"

RSpec.describe GetProductsService, type: :service do
  describe ".call" do
    let(:products) { build_stubbed_list(:product, 3) }

    before do
      allow(Product).to receive(:all).and_return(products)
    end

    subject { described_class.call }

    it "returns all products" do
      expect(subject).to eq(products)
    end
  end
end
