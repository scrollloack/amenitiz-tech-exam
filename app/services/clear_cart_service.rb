class ClearCartService
  def initialize(user_id)
    @redis = $redis
    @key = "cart:#{user_id}"
  end

  def call
    @redis.del(@key)
  end
end
