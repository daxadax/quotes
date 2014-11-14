require 'quotes/services/quote_boundary'

module Quotes
  module UseCases
    class GetQuotes < UseCase

      Quote   = Services::QuoteBoundary::Quote
      Result  = Bound.required( :quotes => [Quote] )

      def call
        Result.new(:quotes => get_quotes)
      end

      private

      def get_quotes
        quotes_gateway.all.map { |quote| quote_boundary.for quote }
      end

    end
  end
end
