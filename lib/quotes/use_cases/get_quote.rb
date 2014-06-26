module Quotes
  module UseCases
    class GetQuote < UseCase

      def initialize(input)
        ensure_valid_input!(input[:id])

        @id = input[:id]
      end

      def call
        gateway.get(@id)
      end

      private

      def ensure_valid_input!(id)
        reason = "The given Quote ID is invalid"

        raise_argument_error(reason, id) unless id.kind_of? Integer || id.nil?
      end

    end
  end
end