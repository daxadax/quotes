class GatewaySpec < Minitest::Spec

  FAKE_DB_FILE = './spec/support/fake_quotes_db'

  before do
    truncate
  end

  def fake_db_file
    FAKE_DB_FILE
  end

  private

  def truncate
    File.truncate(FAKE_DB_FILE, 0)
  end

end