require_relative 'boot'

require 'rails/all'
require 'active_support/core_ext/string'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

eval(<<EOF
module #{(`echo $REPO_URL`.gsub("\n", "").presence || Dir.pwd).split("/").last.gsub(".git","").underscore.camelize}
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Asia/Tokyo'
    config.i18n.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.{rb,yml}"]
    config.autoload_paths << Rails.root.join("lib")

    Dir.glob("config/routes/*").each do |route|
      config.paths["config/routes.rb"] << Rails.root.join(route)
    end
  end
end
EOF
)
