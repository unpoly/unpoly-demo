namespace :db do
  desc 'Deletes all rows in all tables'
  task :clean => :environment do
    DatabaseCleaner.clean_with(:deletion)
  end
end