require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UnpolyDemoLayers
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Restore config/secrets.yml, which was removed in Rails 7.2
    config.require_master_key = false
    config.secrets = config_for(:secrets)
    config.secret_key_base = config.secrets.secret_key_base
    def secrets
      config.secrets
    end
  end
end
