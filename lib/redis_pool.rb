# frozen_string_literal: true

require 'redis'

# Typically we would instantiate Redis in `config/application.rb`, however, when instantiating puma we also invoke
# a new puma server for metrics in parallel which doesn't have context of "Rails". So we need a factory which can
# serve a redis pool and the default configuration to either the Rails (Blip) application or the Metrics server.
class RedisPool
  class << self
    # Obtain a new pool of desired size with redis_config merged into the default redis config
    def set_pool(size: 5, redis_config: {})
      ConnectionPool::Wrapper.new(size: size, timeout: 5) { Redis.new(default_config.merge(redis_config)) }
    end

    # Obtain the default redis config for packages which manage their own pools (like Sidekiq)
    def default_config
      tls_verify = ENV.fetch('REDIS_TLS_VERIFY', 'false').downcase == 'true'
      redis_ssl_params = {}
      redis_ssl_params[:verify_mode] = OpenSSL::SSL::VERIFY_NONE unless tls_verify
      redis_url = ENV.fetch('REDIS_URL', "redis://localhost:6379/0/cache")
      if redis_url
        uri = URI.parse(redis_url)
        ENV['REDIS_ENDPOINT'] = uri.host
        ENV['REDIS_PORT'] = uri.port.to_s
        ENV['REDIS_DB'] = uri.path[1..-1].to_s
        ENV['REDIS_PASSWORD'] = uri.password
      end
      {
        host: ENV.fetch('REDIS_ENDPOINT', 'localhost'),
        port: ENV.fetch('REDIS_PORT', 6379).to_i,
        db: ENV.fetch("RAILS_ENV", "development") == "test" ? (ENV['TEST_ENV_NUMBER'].to_i) : ENV.fetch('REDIS_DB', 0).to_i,
        password: ENV.fetch('REDIS_PASSWORD', nil).presence,
        ssl: (ENV.fetch('REDIS_TLS_ENABLED', 'false').downcase == 'true'),
        ssl_params: redis_ssl_params,
        timeout: 5,
      }.freeze
    end
  end
end
