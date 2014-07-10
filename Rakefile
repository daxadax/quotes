require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

desc "Import quotes"
task :import_quotes do
  require './lib/quotes'

  puts "Importing quotes"
  Tasks::ImportQuotes.new.run
  puts "Quotes imported successfully"
end

namespace :db do
  desc "Run migrations (optionally include version number)"
  task :migrate do
    require "sequel"
    Sequel.extension :migration

    version       = ENV['VERSION']
    default_db    = "sqlite://quotes-development.db"
    database_url  = ENV.fetch("DATABASE_URL", default_db)
    db            = Sequel.connect(database_url)

    if version 
      puts "Migrating to version #{version}" 
      Sequel::Migrator.run(db, "./lib/db_migrations", version.to_i)    
    else
      puts "Migrating"
      Sequel::Migrator.run(db, "./lib/db_migrations")
    end
  end

end
