module Quotes
  module UseCases
    class UseCase
      include Support::ValidationHelpers

      def gateway
        @gateway ||= Gateways::QuotesGateway.new
      end

      def quote_boundary
        @boundary ||= Services::QuoteBoundary.new
      end

    end
  end
end