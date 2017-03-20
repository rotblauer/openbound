Rails.application.config.middleware.use OmniAuth::Builder do
  # https://github.com/mkdynamic/omniauth-facebook
  provider :developer if Rails.env.development?
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
  	:scope => 'email,public_profile,user_education_history', :info_fields => 'id,name,email,education', :display => 'page' # should return default info
end

# # https://github.com/omniauth/omniauth/wiki/Dynamic-Providers
# SETUP_PROC = lambda do |env|
#   env['omniauth.strategy'].options[:consumer_key] = ENV['FACEBOOK_KEY']
#   env['omniauth.strategy'].options[:consumer_secret] = ENV['FACEBOOK_SECRET']
# end

# Rails.application.config.middleware.use OmniAuth::Builder do

#   provider :developer if Rails.env.development?
#   provider :facebook, setup: SETUP_PROC,
#            :scope => 'email,public_profile,user_education_history', :info_fields => 'id,name,email,education', :display => 'page' # should return default info

# end
