# frozen_string_literal: true

class Cache::Redis < Cache::InMemory

  def self.cache
    Rails.configuration.redis
  end

  def self.contains_data?(key)
    cache.exists?(key)
  end

  def self.store_data(k, v, expiration_time=DEFAULT_CACHE_EXPIRATION_TIME)
    cache.set(k, v, ex: expiration_time)
  end

  def self.get_data(k)
    cache.get(k)
  end
end
