set :stage, :production

set :deploy_to, '/var/www/demo.upjs.io/'
set :rails_env, 'production'
set :branch, 'master'

server 'app01-test.demo.makandra.de', user: 'deploy-demo_upjs', roles: %w(app web cron db) # first is primary
server 'app02-test.demo.makandra.de', user: 'deploy-demo_upjs', roles: %w(app web)
