require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # Load defaults from config/*.env in config

    config.active_job.queue_adapter = :sidekiq

    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden

    config.action_cable.disable_request_forgery_protection = false

    Dotenv.load *Dir.glob(Rails.root.join("config/**/*.env"), File::FNM_DOTMATCH)

    # Override any existing variables if an environment-specific file exists
    Dotenv.overload *Dir.glob(Rails.root.join("config/**/*.env.#{Rails.env}"), File::FNM_DOTMATCH)

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_spec: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_specs: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
