# source 'https://rails-assets.org' do
#   gem 'rails-assets-tether', '>= 1.3.3'
# end


source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

gem 'pg'
gem 'postgres_ext'

## DEPLOY GEMS
# use Puma for deploy server with EB
gem 'puma'

# Use bcrypt for password crypto v
# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.9'
# Use faker for generating fake seed data
gem 'faker', '1.4.2'

## IHA commented #20150713 trying to fix mobile clicking issue.
# Use angular-rails-csrf for post token auth
# gem 'angular_rails_csrf'
gem 'active_model_serializers'

############################################
## Analytics
############################################

# https://github.com/ankane/ahoy
gem 'ahoy_matey'
gem 'activeuuid', '>= 0.5.0'
gem "chartkick"
gem "groupdate"
gem "hightop"
# https://github.com/thirtysixthspan/descriptive_statistics
# You have requested:
#   descriptive_statistics ~> 2.4.0

# The bundle currently has descriptive_statistics locked at 2.5.1.
# Try running `bundle update descriptive_statistics`
gem 'descriptive_statistics', :require => 'descriptive_statistics/safe' #'~> 2.4.0',


############################################
## Mailers and Delayers
############################################

gem 'gibbon'
gem 'delayed_job_active_record'

############################################
## JavaScript & CSS language libraries
############################################

# Use jquery as a JavaScript library <-- need this for :DELETE method to work right in erb (and jquery_ujs required as per default)
gem 'jquery-rails'
# Use best_in_place for in-line editing of work.name and maybe some other stuff later
gem 'best_in_place', '~> 3.0.1'
# Use Angularjs for sweet javascripting
# Angular.min is incorporated through the asset pipeline and managed by Bower.
# gem 'angularjs-rails'
# gem 'angular-rails-templates'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use Bootstrap Sass for formatting (.scss)
# gem 'bootstrap-sass', '>=3.2.0.0'
# gem 'bootstrap', '~> 4.0.0.alpha6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'font-awesome-sass'

## IHA don't know bout these two 20150216
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

############################################
## Uploads, document conversions & formatting, and querying
############################################

# ----------- Uploads ------------ #

## Removed github version because I think eb was having a problem with it. 20150624. IHA.
#, github: 'Springest/jquery-fileupload-rails' # This is a more recently maintained branch.
gem 'jquery-fileupload-rails'
gem 'carrierwave'
# Use Fog for CarrierWave S3 file storage.
gem "fog-aws" #, "~> 1.3.1"

# ----------- Conversions & Formatting ------------ #

# You have to have both mini and r.
# gem 'mini_magick'
gem 'rmagick', '2.13.2', require: false # :require => 'RMagick' #, require: false # redundant to mini_magick (creates circular reference)
# gem 'mini_magick'
# Enables asynch batch uploading via AJAX (note: depends on jquery-rails gem)
gem 'remotipart', '~> 1.2'
# Enables file_size validation
gem 'file_validators' # https://github.com/musaffa/file_validators before upload

## Gems for parsing, reading, anad rendering to- and from- markdown, files, and html
gem 'word-to-markdown', '1.1.7' #, '1.1.3' is on production; 1.1.5 is updated  ## REQUIRES LIBREOFFICE
gem 'yomu'
gem 'reverse_markdown'
gem 'pandoc-ruby'
# gem 'wdiff'
gem 'diffy' # https://github.com/samg/diffy
# gem 'docsplit'
# gem 'carrierwave-docsplit'
gem 'html-pipeline'
gem 'github-markdown' ## dependency for html-pipline
# Enables, like, html_escape method.
gem 'escape_utils'
# Markdown rendering pipeline.
gem 'redcarpet'
# For parsing html.
gem 'nokogiri', '1.6.6.2' #, '1.5.0'
# for paging with angular arpaging directive (.per(10) etc)
gem 'kaminari'
# for decoding html entities in markdown and html
gem 'htmlentities'

## Gems for work metadata
# Use tagging
# gem 'acts-as-taggable-on'
# Use impressionist for page views counts
gem 'impressionist', '1.5.1'
# Use folder system for uploads && nested comments(?)
# gem 'acts_as_tree'

## Gems for querying work documents
gem 'textacular', '~> 3.0'
gem 'acts-as-taggable-array-on'

gem 'progress_bar'

# Use Devise for User Authentication -- at least for users :trackable
gem 'devise'

# Oauth.
gem 'omniauth'
gem 'omniauth-facebook'

# Counter culture gem should fix double counting on belong_to counter_cache.
# As of 4.2 Rails this issue is still unresolved in the master branch, with no obvious workaround.
gem 'counter_culture', '~> 0.1.33'

# Use FriendlyID for generating sexy permalink slugs for works, users, and schools.
gem 'friendly_id', '~> 5.1.0'
gem 'fuzzily' # for fuzzy school name finding

# Use SWOT to check if email are academic.
# https://github.com/leereilly/swot
gem 'swot'

# Use Shareable for easy share button for Facebook, Twitter
# https://github.com/hermango/shareable
gem 'shareable'

gem 'colorize' # for making ruby output colored. fancy.

# Use High Charts gem
gem 'lazy_high_charts'

gem 'time_difference'

gem 'wikipedia-client'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Staging should be identical to production.
group :production do
  # Use for batch async upload.
  gem 'rack-cache', :require => 'rack/cache'
  gem "daemons"
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # This is a dependency for Rubber.
  # gem 'therubyracer', platforms: :ruby
end

group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  # gem "capistrano-scm-gitcopy", require: false
  gem 'rvm-capistrano', require: false

  gem 'web-console', '~> 2.0'
  # gem 'db_fixtures_dump'

  gem 'seed_dump'
  gem 'table_print'

  gem 'bullet'
  gem 'query_diet'
  gem 'rack-mini-profiler'
end


group :development, :test do
  # Testing with RSpec and Factory Girl.
  gem 'rspec-rails'
  gem 'factory_girl_rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Better errors for better errors
  gem 'better_errors'

end

group :test do
  # gem 'faker' # <-- got it already!
  gem 'capybara' # <-- "programatically simulates user's interactions with site"
  gem 'guard-rspec' # <-- "watches your application and tests and runs specs for you automatically when it detects changes"
  gem 'launchy' # <-- "opens your defaults web browser upon failed specs to show you what your application is rendering"
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end
