# Use this file to define all cron jobs that are installed by Capistrano.
# Learn more: http://github.com/javan/whenever

every 1.day, at: '03:53 am' do
  runner 'Tenant.clean!'
end
