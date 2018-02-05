require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AirPollution
  class Application < Rails::Application
    config.active_job.queue_adapter = ActiveJob::GoogleCloudPubsub::Adapter.new(
      async:  false,
      logger: nil,
      pubsub: Google::Cloud::Pubsub.new(
        project: 'luft-184208',
        keyfile: Rails.root.join('credentials', 'luft-cbbb936544ad.json')
      )
    )
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.x.settings = Rails.application.config_for :settings
    config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
    config.time_zone = 'Copenhagen'
    config.active_record.default_timezone = :local

    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => 'http://my-web-service-consumer-site.com',
      'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")
    }
  end
end
