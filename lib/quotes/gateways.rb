require 'quotes/gateways/gateway'
require 'quotes/gateways/backend'
Dir.glob('./lib/quotes/gateways/*.rb') { |f| require f }

module Gateways
end
