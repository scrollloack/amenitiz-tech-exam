require "rails_helper"

RSpec.describe RedisRepository do
  let(:mock_redis) { instance_double("Redis") }
  let(:key) { "cart:test-user" }

  subject { described_class.new(key, mock_redis) }

  describe "#expiration_time" do
    it "returns 2 hours in seconds" do
      expect(subject.expiration_time).to eq(7200)
    end
  end

  describe "#expire" do
    it "sets the expiration time on the key" do
      expect(mock_redis).to receive(:expire).with(key, 7200)
      subject.expire
    end
  end

  describe "#fetch" do
    it "retrieves the value for the key from Redis" do
      expect(mock_redis).to receive(:get).with(key).and_return("some_data")
      expect(subject.fetch).to eq("some_data")
    end
  end

  describe "#save" do
    it "saves data to Redis under the key" do
      expect(mock_redis).to receive(:set).with(key, "serialized_data")
      subject.save("serialized_data")
    end
  end
end
