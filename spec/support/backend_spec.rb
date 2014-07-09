class BackendSpec < Minitest::Spec

  before do
    run_migrations
  end

  after do
    File.delete('./quotes-test.db')
  end

  def run_migrations
    Sequel.extension :migration

    Sequel::Migrator.apply(database, "./lib/db_migrations/")
  end

  def reset_test_database
    database.drop_table?(:quotes)
  end

  def database
    @database ||= Sequel.connect(ENV.fetch("DATABASE_URL"))
  end

end