# spec/requests/errors_controller_spec.rb
require "rails_helper"

RSpec.describe "ErrorsController", type: :request do
  describe "GET /not_found" do
    it "renders the 404.html page with 404 status and no layout" do
      get "/not_found"

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("The page you were looking for")
    end
  end

  describe "GET /some-missing-page" do
    it "renders the 404.html page with 404 status and no layout" do
      get "/some-missing-page"

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("The page you were looking for") # Adjust if custom content
    end
  end

  describe "POST /totally/invalid" do
    it "renders the 404.html page with 404 status for unsupported POST path" do
      post "/totally/invalid"

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("The page you were looking for")
    end
  end
end
