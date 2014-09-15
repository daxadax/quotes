require 'bundler'
Bundler.setup

require 'persistence'
require 'json'

module Quotes
  module Gateways
    class Gateway
      include Support::ValidationHelpers

      def backend_for_quotes
        Persistence::Gateways::QuotesGatewayBackend.new
      end

    end
  end
end