require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MecTask01
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += Dir[Rails.root.join('app', 'serializers', '{**}')]

    # config.active_job.queue_adapter = :delayed_job
    config.active_job.queue_adapter = :sidekiq

    # config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 90.minutes }
  end
end
