# encoding: UTF-8

# unicorn configuration for development
require 'fileutils'

# required data
env = ENV['RACK_ENV']

# Set the current app's path for later reference. Rails.root isn't available at
# this point, so we have to point up a directory.
app_dir = File.expand_path('../..', __FILE__)
#app_path = File.expand_path(File.dirname(__FILE__) + '/..')

pids_file = "unicorn.dev.pid"
pids_dir  = "#{app_dir}/tmp/pids"
::FileUtils.mkdir_p "#{pids_dir}"

log_file = "unicorn.#{env}.log"
log_dir  = "#{app_dir}/log"
::FileUtils.mkdir_p "#{log_dir}"

# unicorn configuration
working_directory app_dir
pid "#{pids_dir}/#{pids_file}"
stderr_path "#{log_dir}/#{log_file}"
stdout_path "#{log_dir}/#{log_file}"
listen "127.0.0.1:#{ENV['PORT'] || '3000'}"
worker_processes 1
timeout 240


# Load the app up before forking.
preload_app true

# Garbage collection settings.
GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true

# If using ActiveRecord, disconnect (from the database) before forking.
before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

# After forking, restore your ActiveRecord connection.
after_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
