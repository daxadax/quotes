module Quotes
  module UseCases
    class UpdateQuote < UseCase

      Result = Bound.required(:error, :uid)

      def initialize(input)
        @user_uid = input[:user_uid]
        @uid = input[:uid]
        @updates = input[:updates]
      end

      def call
        quote = quotes_gateway.get uid

        return failure(:quote_not_found) unless quote
        return failure(:invalid_user) unless user_uid == quote.added_by

        Result.new(:error => nil, :uid => update(quote))
      end

      private

      def failure(msg)
        Result.new(:error => msg, :uid => nil)
      end

      def update(quote)
        fetch_updated_publication if publication_updated?(quote)

        quote.update(updates)
        quotes_gateway.update quote
      end

      def publication_updated?(quote)
        return false unless updates[:publication_uid]
        return true if updates[:publication_uid] != quote.publication_uid
      end

      def fetch_updated_publication
        uid = updates[:publication_uid]
        updates[:publication] = publications_gateway.get uid
      end

      def uid
        @uid
      end

      def user_uid
        @user_uid
      end

      def updates
        @updates
      end

    end
  end
end
