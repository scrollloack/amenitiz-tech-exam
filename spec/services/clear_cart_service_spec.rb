require "rails_helper"

RSpec.describe ClearCartService, type: :service do
  describe ".call" do
    let(:key) { "cart:#{user_id}" }
    let(:mock_redis) { instance_double("Redis") }
    let(:user_id) { "fake-session-user-id" }

    before do
      stub_const("::ClearCartService::GLOBAL_REDIS", mock_redis)
      $redis = mock_redis
    end

    subject { described_class.new(user_id).call }

    it "deletes the cart from redis" do
      expect(mock_redis).to receive(:del).with(key)

      subject
    end
  end
end
