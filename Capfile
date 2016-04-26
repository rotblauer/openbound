gemfile = File.expand_path(File.join(__FILE__, '..', 'Gemfile'))
if File.exist?(gemfile) && ENV['BUNDLE_GEMFILE'].nil?
  puts "Respawning with 'bundle exec'"
  exec("bundle", "exec", "cap", *ARGV)
end

load 'deploy' if respond_to?(:namespace) # cap2 differentiator


# env = ENV['RUBBER_ENV'] ||= (ENV['RAILS_ENV'] || 'production')
# ...
## === Replace this line ===
# env = ENV['RUBBER_ENV'] ||= ...

## === With the following code ===
## So that we can do `cap staging deploy` instead of RUBBER_ENV=staging cap deploy
env = ARGV.shift
# Default to vagrant if not provided
stages = %w( staging production )
default_stage = 'production'
unless stages.include?(env)
  # using default stage, put that argument back
  ARGV.unshift(env)
  env = default_stage
end
ENV['RUBBER_ENV'] = ENV['RAILS_ENV'] = env


root = File.dirname(__FILE__)

# this tries first as a rails plugin then as a gem
$:.unshift "#{root}/vendor/plugins/rubber/lib/"
require 'rubber'

Rubber::initialize(root, env)
require 'rubber/capistrano'

Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
# load 'deploy/assets'
load 'config/deploy'
