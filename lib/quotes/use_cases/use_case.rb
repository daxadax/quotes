module Quotes
  module UseCases
    class UseCase
      include Support::ValidationHelpers

      def quotes_gateway
        @__quotes_gateway ||= Gateways::QuotesGateway.new
      end

      def publications_gateway
        @__publications_gateway ||= Gateways::PublicationsGateway.new
      end

      def quote_boundary
        @__quote_boundary ||= Services::QuoteBoundary.new
      end

      def ensure_valid_input!(uid)
        reason = "The given UID is invalid"

        unless uid.kind_of? Integer || uid.nil?
          raise_argument_error(reason, uid)
        end
      end

    end
  end
end
