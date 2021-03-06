require_relative 'boot'

require 'rails/all'
require 'rspec-rails'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UnimatchRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    config.autoload_paths += %W(#{config.root}/lib/connector)
    ActiveSupport::JSON::Encoding.time_precision = 3
  end
end
