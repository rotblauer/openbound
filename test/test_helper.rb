ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require 'fileutils'
Minitest::Reporters.use!
include ActionDispatch::TestProcess

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  fixtures :schools
  fixtures :users
  fixtures :affiliations
  fixtures :projects
  fixtures :works

  # # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  #  # Logs in a test user.
  def log_in_as(user, options = {})
    password    = options[:password]    || 'fluffy'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

 def after_teardown
    # super
   carrierwave_root = Rails.root.join('test','support','carrierwave')
    # CarrierWave.clean_cached_files!(0) #puts "Removing carrierwave test directories:"
    Dir.glob(carrierwave_root.join('*')).each do |dir|
      #puts "   #{dir}"
      FileUtils.remove_entry(dir)
    end
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end

  # Add more helper methods to be used by all tests here...
end

# Carrierwave setup and teardown
carrierwave_template = Rails.root.join('test','fixtures','files')
carrierwave_root = Rails.root.join('test','support','carrierwave')

# # Makes things work for testing work uploads.
CarrierWave.configure do |config|
  config.root = Rails.root.join('test', 'fixtures', 'files')
	config.storage = :file
	config.enable_processing = false
  config.cache_dir = Rails.root.join('test','support','carrierwave','carrierwave_cache')
end
# And copy carrierwave template in
#puts "Copying\n  #{carrierwave_template.join('uploads').to_s} to\n  #{carrierwave_root.to_s}"
FileUtils.cp_r carrierwave_template.join('uploads'), carrierwave_root


# # For Work upload testing.
# class CarrierWave::Mount::Mounter
#   def store!
#     # Not storing uploads in the tests
#     return
#   end
# end
