require_relative "boot"

require "rails/all"

# # タイムゾーンを日本にする
# config.time_zone = "Tokyo"
# # デフォルトのロケールを日本にする
# config.i18n.default_local = :ja

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qanda
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.generators.template_engine = :slim
  end
end
