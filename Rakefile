require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

namespace :db do
  desc "Run migrations"
  task :migrate do |t, args|
    require "sequel"
    Sequel.extension :migration

    default_db    = "sqlite://quotes-development.db"
    database_url  = ENV.fetch("DATABASE_URL", default_db)
    db            = Sequel.connect(database_url)

    puts "Migrating"
    Sequel::Migrator.run(db, "./lib/db_migrations")
  end
end