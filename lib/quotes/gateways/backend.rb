require 'sqlite3'
require 'sequel'

module Gateways
  class Backend < Gateway

    DB = Sequel.sqlite

  end
end