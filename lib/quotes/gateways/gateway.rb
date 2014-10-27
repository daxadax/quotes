require 'bundler'
Bundler.setup

require 'persistence'
require 'json'

module Quotes
  module Gateways
    class Gateway
      include Support::ValidationHelpers

      def backend_for_quotes
        @quotes_gateway_backend ||= new_backend
      end

      private

      def new_backend
        Persistence::Gateways::QuotesGatewayBackend.new
      end

    end
  end
end