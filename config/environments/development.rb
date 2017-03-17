Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # http://stackoverflow.com/questions/1114388/rails-reloading-lib-files-without-having-to-restart-server
  # ActiveSupport::Dependencies.autoload_paths << File::join( Rails.root, 'lib')
  # ActiveSupport::Dependencies.explicitly_unloadable_constants << 'ConverterMachine'
  # ActiveSupport::Dependencies.explicitly_unloadable_constants << 'Filetypeable'


  # Devise installation instructions:
    # 1. Ensure you have defined default url options in your environments files. Here
    #  is an example of default_url_options appropriate for a development environment
    #  in config/environments/development.rb:

  ## 4 commented; changing to live. 
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :test
  host = 'localhost:3000'
  config.action_mailer.default_url_options = { host: host }

  # config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  #  In production, :host should be set to the actual host of your application.

  # config.serve_static_files = false

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.after_initialize do
    Bullet.enable = true
    # Bullet.alert = false
    Bullet.bullet_logger = true
    Bullet.console = true
    # Bullet.growl = false
    # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
    #                 :password => 'bullets_password_for_jabber',
    #                 :receiver => 'your_account@jabber.org',
    #                 :show_online_status => true }
    Bullet.rails_logger = true
    # Bullet.honeybadger = false
    # Bullet.bugsnag = false
    # Bullet.airbrake = false
    # Bullet.rollbar = false
    Bullet.add_footer = true
    # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
    # Bullet.stacktrace_excludes = [ 'their_gem', 'their_middleware' ]
    # Bullet.slack = { webhook_url: 'http://some.slack.url', channel: '#default', username: 'notifier' }

    # Bullet.add_whitelist :type => :n_plus_one_query, :class_name => "Post", :association => :comments
    # Bullet.add_whitelist :type => :unused_eager_loading, :class_name => "Post", :association => :comments
    # Bullet.add_whitelist :type => :counter_cache, :class_name => "Country", :association => :cities
  end

end
