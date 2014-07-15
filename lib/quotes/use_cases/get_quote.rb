module Quotes
  module UseCases
    class GetQuote < UseCase

      Quote   = Services::QuoteBoundary::Quote
      Result  = Bound.required( :quote => Quote )

      def initialize(input)
        ensure_valid_input!(input[:id])

        @id = input[:id]
      end

      def call
        Result.new(:quote => get_quote)
      end

      private

      def get_quote
        quote = gateway.get(@id)

        quote_boundary.for quote
      end

      def ensure_valid_input!(id)
        reason = "The given Quote ID is invalid"

        raise_argument_error(reason, id) unless id.kind_of? Integer || id.nil?
      end

    end
  end
end