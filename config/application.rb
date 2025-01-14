require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module HDeats
  class Application < Rails::Application
    # 日本語ロケールをデフォルトに設定
    config.i18n.default_locale = :ja
    config.load_defaults 7.0
    config.active_storage.variant_processor = :mini_magick
  end
end
