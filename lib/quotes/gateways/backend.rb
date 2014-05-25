require 'sqlite3'
require 'sequel'

module Quotes
  module Gateways
    class Backend
      include Support::ValidationHelpers

      def initialize
        @database = retrieve_database
      end

      private

      def retrieve_database
        if ENV['test']
          database = Sequel.connect('sqlite://quotes-test.db')
        else
          database = Sequel.connect('sqlite://quotes-development.db')
        end
      end
    end
  end
end