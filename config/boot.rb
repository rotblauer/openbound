ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

# added this per http://stackoverflow.com/questions/11478316/incompatible-character-encodings-utf-8-and-ascii-8bit/16737583#16737583
# to try to fix encoding
# ENV['NLS_LANG'] = 'AMERICAN_AMERICA.UTF8'


require 'bundler/setup' # Set up gems listed in the Gemfile.
