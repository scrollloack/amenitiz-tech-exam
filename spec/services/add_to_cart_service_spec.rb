require "rails_helper"

RSpec.describe AddToCartService, type: :service do
  describe ".call" do
    let(:data) { { product_code: "GR1", quantity: 2 } }
    let(:key) { "cart:#{user_id}" }
    let(:product) { build_stubbed(:product, product_code: "GR1", name: "Green Tea", price: 3.11) }
    let(:promotion) { instance_double("ProductHelpers::Prices::Base") }
    let(:redis_repo) { instance_double(RedisRepository) }
    let(:user_id) { "fake-user-id" }

    let(:cart_item) do
      {
        "product_code" => "GR1",
        "name" => "Green Tea",
        "price" => 3.11,
        "quantity" => 2
      }
    end
    let(:expected_final_cart) do
      {
        "GR1" => {
          "product_code" => "GR1",
          "name" => "Green Tea",
          "price" => 3.11,
          "quantity" => total_quantity,
          "total_price" => total_price
        }
      }
    end

    subject { described_class.new(data, user_id).call }

    before do
      allow(ProductRepository).to receive(:find_by).and_return(product)
      allow(::Factories::PromotionFactory).to receive(:build).and_return(promotion)
      allow(RedisRepository).to receive(:new).and_return(redis_repo)
    end

    after do |test|
      subject unless test.metadata[:skip_after]
    end

    context "when the cart already exists in redis" do
      let(:total_price) { 12.44 }
      let(:total_quantity) { 4 }

      let(:existing_cart_hash) do
        {
          "GR1" => {
            "product_code" => "GR1",
            "name" => "Green Tea",
            "price" => 3.11,
            "quantity" => 2,
            "total_price" => 6.22
          }
        }
      end

      before do
        allow(ProductsHelper::CartItemBuilder).to receive(:new)
          .and_return(double(call: existing_cart_hash["GR1"].dup))
        allow(redis_repo).to receive(:fetch).and_return(existing_cart_hash.to_json)
        allow(redis_repo).to receive(:save)
        allow(redis_repo).to receive(:expire)
        allow(promotion).to receive(:effective_quantity).and_return(4)
        allow(promotion).to receive(:total_price).and_return(12.44)
      end

      it "parses and uses the existing cart from redis" do
        expect(RedisRepository).to receive(:new).with(key)

        expect(subject["quantity"]).to eq(4)
        expect(subject["total_price"]).to eq(12.44)

        expect(ProductRepository).to have_received(:find_by)
          .with({ product_code: "GR1" })

        expect(::Factories::PromotionFactory).to have_received(:build)
          .with("GR1")

        expect(ProductsHelper::CartItemBuilder).to have_received(:new)
          .with(expected_final_cart.deep_dup, "GR1", product, 2)

        expect(redis_repo).to have_received(:save)
          .with(expected_final_cart.to_json)
      end
    end

    context "when the cart does not yet exists in redis" do
      let(:total_price) { 9.33 }
      let(:total_quantity) { 3 }

      let(:existing_cart) do
        {
          "GR1" => {
            "product_code" => "GR1",
            "name" => "Green Tea",
            "price" => 3.11,
            "quantity" => 1,
            "total_price" => 3.11
          }
        }
      end

      before do
        allow(ProductsHelper::CartItemBuilder).to receive(:new)
          .and_return(double(call: existing_cart["GR1"].deep_dup))
        allow(redis_repo).to receive(:fetch).and_return(existing_cart)
        allow(redis_repo).to receive(:save)
        allow(redis_repo).to receive(:expire)
        allow(promotion).to receive(:effective_quantity).and_return(3)
        allow(promotion).to receive(:total_price).and_return(9.33)
      end

      it "uses the unparsed hash directly without JSON parsing" do
        expect(RedisRepository).to receive(:new).with(key)

        expect(subject["quantity"]).to eq(3)
        expect(subject["total_price"]).to eq(9.33)

        expect(ProductRepository).to have_received(:find_by)
          .with({ product_code: "GR1" })

        expect(::Factories::PromotionFactory).to have_received(:build)
          .with("GR1")

        expect(ProductsHelper::CartItemBuilder).to have_received(:new)
          .with(expected_final_cart, "GR1", product, 2)

        expect(redis_repo).to have_received(:save)
          .with(expected_final_cart.to_json)
      end
    end
  end
end
