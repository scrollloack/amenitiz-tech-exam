class RedisRepository
  def initialize(key)
    @key = key
    @redis = $redis
  end

  def expiration_time
    2 * 60 * 60 # 2 hours
  end

  def expire
    @redis.expire(@key, expiration_time)
  end

  def fetch
    @redis.get(@key)
  end

  def save(data)
    @redis.set(@key, data)
  end
end
