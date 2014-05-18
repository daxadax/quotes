require 'json'

module Gateways
  class Gateway
    include Support::ValidationHelpers

    def backend_for_quotes
      Gateways::QuotesGatewayBackend.new
    end

  end
end