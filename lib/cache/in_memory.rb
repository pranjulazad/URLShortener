# frozen_string_literal: true

# strategy (Design Pattern)
# Liskov substitution principle (Solid)

class Cache::InMemory
  def self.store_data(k, v, expiration_time=DEFAULT_CACHE_EXPIRATION_TIME)
    raise "Not Implemented"
  end

  def self.get_data(k)
    raise "Not Implemented"
  end

  def self.contains_data?(k)
    raise "Not Implemented"
  end
end
