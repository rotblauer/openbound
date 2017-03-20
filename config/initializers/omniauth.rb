Rails.application.config.middleware.use OmniAuth::Builder do
  # https://github.com/mkdynamic/omniauth-facebook
  provider :developer if Rails.env.development?
  provider :facebook, Rails.application.secrets.facebook_key, Rails.application.secrets.facebook_secret,
  	:scope => 'email,public_profile,user_education_history', :info_fields => 'id,name,email,education', :display => 'page' # should return default info
end
