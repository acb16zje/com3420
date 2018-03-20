#####
#
# These are required to make rvm work properly within crontab
#
if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  env "PATH",         ENV["PATH"]
  env "GEM_HOME",     ENV["GEM_HOME"]
  env "MY_RUBY_HOME", ENV["MY_RUBY_HOME"]
  env "GEM_PATH",     ENV["_ORIGINAL_GEM_PATH"] || ENV["BUNDLE_ORIG_GEM_PATH"] || ENV["BUNDLER_ORIG_GEM_PATH"]
end
#
#####
require 'date'
require 'rake'
env :MAILTO, 'systems@epigenesys.org.uk'
set :output, { standard: 'log/whenever.log' }
env :PATH, ENV['PATH']

every :reboot, roles: [ :db ] do
  runner "require 'delayed/command'; Delayed::Command.new(['-p #{@delayed_job_args_p}', '-n #{@delayed_job_args_n}', 'start']).daemonize"
end

# every 30 seconds
every (0.5).minutes do
  rake "update_booking_status_to_ongoing"
  rake "update_booking_status_to_late"
end

every 1.day do
  runner "daily_task.rb"
end
