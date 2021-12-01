set :stage, :production

set :deploy_to, '/var/www/demo.upjs.io/'
set :rails_env, 'production'
set :branch, 'master'

server 'app01-prod.makandra.makandra.de', user: 'deploy-demo_upjs', roles: %w(app web db) # first is primary
server 'app02-prod.makandra.makandra.de', user: 'deploy-demo_upjs', roles: %w(app web cron)
