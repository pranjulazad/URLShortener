require_relative "boot"

require "rails/all"
require "byebug"
require 'uri'
require 'securerandom'
require_relative '../lib/redis_pool'

default_cache_expiration_time = 86400 # seconds (1 day)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestStore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    #config.autoload_lib(ignore: %w(assets tasks))

    config.autoloader = :zeitwerk

    config.autoload_paths += %W(
    #{config.root}/lib
    )
    config.eager_load_paths += %W(
    #{config.root}/lib
    )

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_record.cache_versioning = false
    config.redis_config = RedisPool.default_config
    Rails.application.config.redis = RedisPool.set_pool(size: 10, redis_config: config.redis_config)
    config.cache_store = :redis_store, Rails.configuration.redis_config.merge(namespace: "cache")

    # logging
    config.logger = Logger.new(STDOUT)
    config.log_level = :info
  end
end
