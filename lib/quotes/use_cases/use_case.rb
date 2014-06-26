module Quotes
  module UseCases
    class UseCase
      include Support::ValidationHelpers

      def gateway
        @gateway ||= Gateways::QuotesGateway.new
      end

    end
  end
end