# frozen_string_literal: true

TestStore::Application.config.session_store :redis_store,
                                            servers: Rails.configuration.redis_config.merge(namespace: "session"),
                                            key: "_test_store_session",
                                            secure: Rails.env.production?,
                                            expire_after: 15.days,
                                            threadsafe: true
