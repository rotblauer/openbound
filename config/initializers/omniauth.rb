Rails.application.config.middleware.use OmniAuth::Builder do
  # https://github.com/mkdynamic/omniauth-facebook
  provider :developer if Rails.env.development?
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
  	:scope => 'email,public_profile,user_education_history', :info_fields => 'id,name,email,education', :display => 'page' # should return default info
end