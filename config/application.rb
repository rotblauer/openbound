require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'fog/aws'
require 'carrierwave'


#added for to import the schools table
# require 'csv'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(*Rails.groups)

# http://stackoverflow.com/questions/15538050/rails-env-staging-cap-deploy-fails-on-rake-precompile-assets
if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test), :profiling => %w[development])) #staging
end

module Openbound
  class Application < Rails::Application

    # config.autoload_paths += Dir["#{config.root}/lib/**/"] if Rails.env.development?

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Set time zone to Harvard Time.
    config.time_zone = 'Eastern Time (US & Canada)'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    # Bower asset paths
    root.join('vendor', 'assets', 'bower_components').to_s.tap do |bower_path|
      config.sass.load_paths << bower_path
      config.assets.paths << bower_path
    end
    # Precompile Bootstrap fonts
    config.assets.precompile << %r(bootstrap-sass/assets/fonts/bootstrap/[\w-]+\.(?:eot|svg|ttf|woff2?)$)
    config.assets.precompile += %w(*.svg *.eot *.woff *.ttf)
    # config.assets.precompile << %r(octicons/[\w-]+\.(?:eot|svg|ttf|woff2?)$)
    # Minimum Sass number precision required by bootstrap-sass
    ::Sass::Script::Value::Number.precision = [8, ::Sass::Script::Value::Number.precision].max

    # config.autoload_paths += %W(#{config.root}/lib)

    # config.assets.paths << Rails.root.join('public', 'uploads', 'work', 'document') if !Rails.env.production?
    # config.assets.precompile += [/.*\.jpg/,/.*\.pdf/]
    # config.assets.paths << Rails.root.join('lib', 'assets', 'docsplit')

    # added per http://stackoverflow.com/questions/5286117/incompatible-character-encodings-ascii-8bit-and-utf-8
    # see also environmnet.rb
    # this tells Rails "how to interpret content"
    config.encoding = "utf-8"

    config.active_job.queue_adapter = :delayed_job

    # LOAD ENV VARS from local_env.yml.
    # http://railsapps.github.io/rails-environment-variables.html
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => true,
        :routing_specs => true,
        :controller_specs => true,
        :request_specs => true
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  end
end
