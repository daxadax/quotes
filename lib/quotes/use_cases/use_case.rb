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

      def ensure_valid_input!(uid)
        reason = "The given Quote UID is invalid"

        unless uid.kind_of? Integer || uid.nil?
          raise_argument_error(reason, uid)
        end
      end

    end
  end
end