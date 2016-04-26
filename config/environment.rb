# Load the Rails application.
require File.expand_path('../application', __FILE__)

# added per http://stackoverflow.com/questions/5286117/incompatible-character-encodings-ascii-8bit-and-utf-8
# addendum: ruby 1.9+ is utf8 by default. 
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initialize the Rails application.
Rails.application.initialize!
