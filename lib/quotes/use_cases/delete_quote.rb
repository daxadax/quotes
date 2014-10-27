module Quotes
  module UseCases
    class DeleteQuote < UseCase

      def initialize(input)
        ensure_valid_input!(input[:uid])

        @uid = input[:uid]
      end

      def call
        gateway.delete(@uid)
      end

    end
  end
end