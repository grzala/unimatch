namespace :db do

  desc "Truncate all existing data"
  task clean: :environment do
    puts "truncating db"
    DatabaseCleaner.clean_with :truncation
  end

end