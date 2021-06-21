# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :repo_url, 'git@github.com:unpoly/unpoly-demo.git'
set :application, "unpoly-demo"
set :scm, :git

# Default value for :log_level is :debug
set :log_level, :info # %i(debug info error), default: :debug

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/secrets.yml)

# Default value for linked_dirs is []
set :linked_dirs, %w(log public/system tmp/pids)

# Default value for keep_releases is 5
set :keep_releases, 10

set :ssh_options, {
  forward_agent: true
}

# Install new Ruby version if not already installed
after 'deploy:updating', 'opscomplete:ruby:ensure'
