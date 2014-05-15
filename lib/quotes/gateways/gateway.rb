module Gateways
  class Gateway
    include Support::ValidationHelpers

    DB_FILE = './lib/persistence/quotes_db_file'

    def quotes_db_file
      handle_missing_file

      DB_FILE
    end

    private

    def handle_missing_file
      msg = "Please create '#{DB_FILE}'"
      raise RuntimeError, msg unless File.exists?(DB_FILE)
    end

  end
end
