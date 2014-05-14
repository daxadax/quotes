require "quotes/version"

# require all support files
Dir.glob('./lib/quotes/support/*.rb')  { |f| require f }

require "quotes/entities"
require "quotes/services"
require "quotes/tasks"

module Quotes
end
