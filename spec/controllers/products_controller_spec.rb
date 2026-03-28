require "rails_helper"

RSpec.describe "ProductsController", type: :request do
  let(:mock_session) { ActionController::TestSession.new(session_id: user_id) }
  let(:user_id) { "test-session-id" }

  describe "GET /products" do
    let(:products) { build_stubbed_list(:product, 3) }

    before do
      allow(GetProductsService).to receive(:call).and_return(products)
    end

    context "when /products endpoint is called" do
      it "returns a successful response and renders the checkout page view" do
        get "/products"

        expect(response).to have_http_status(:ok)

        expect(response.body).to include(products.first.name)
      end
    end
  end

  describe "POST /products/add_to_cart" do
    let(:params_data) { { data: { product_code: product.product_code, quantity: 2 } } }
    let(:product) { build_stubbed(:product, product_code: "GR1", name: "Green Tea", price: 3.11) }

    let(:cart_response) do
      {
        product_code: "GR1",
        name: "Green Tea",
        quantity: 2,
        price: 3.11,
        total_price: 6.22
      }
    end
    let(:expected_params) do
      ActionController::Parameters.new(
        product_code: "GR1",
        quantity: "2"
      ).permit!
    end

    before do
      allow(AddToCartService).to receive_message_chain(:new, :call)
        .and_return(cart_response)
      allow_any_instance_of(ProductsController).to receive(:session).and_return(mock_session)
    end

    context "when /products/add_to_cart endpoint is called" do
      it "calls the AddToCartService and returns a JSON response" do
        post "/products/add_to_cart", params: params_data

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json).to include("product_code" => "GR1", "quantity" => 2, "total_price" => 6.22)

        expect(AddToCartService).to have_received(:new) do |params, uid|
          expect(params).to eq(expected_params)
          expect(uid).to be_present
          expect(uid).to be_a Rack::Session::SessionId
        end
      end
    end
  end

  describe "DELETE /products/clear_cart" do
    before do
      allow(ClearCartService).to receive_message_chain(:new, :call)
        .and_return(double(call: true))
      allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(mock_session)
    end

    context "when /products/clear_cart endpoint is called" do
      it "clears the cart and returns no content" do
        delete "/products/clear_cart"

        expect(ClearCartService).to have_received(:new) do |uid|
          expect(uid).to be_present
          expect(uid).to be_a Rack::Session::SessionId
        end

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
