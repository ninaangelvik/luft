require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AirPollution
  class Application < Rails::Application
    config.active_job.queue_adapter = :pub_sub_queue
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.x.settings = Rails.application.config_for :settings
    config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
  end
end
