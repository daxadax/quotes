module Quotes
  module UseCases
    class UpdateQuote < UseCase

      Result = Bound.required(:error, :uid)

      def initialize(input)
        @user_uid = input[:user_uid]
        @quote = input[:quote]
      end

      def call
        Result.new(:error => error, :uid => update_quote)
      end

      private

      def error
        return :invalid_input unless valid?
        return :invalid_user unless user_uid == quote[:added_by]
      end

      def update_quote
        update_in_gateway build_quote unless error
      end

      def build_quote
        added_by = user_uid
        content = quote.delete(:content)
        publication = publications_gateway.get(quote.delete(:publication_uid))
        options = quote

        Entities::Quote.new(added_by, content, publication, options)
      end

      def update_in_gateway(quote)
        quotes_gateway.update quote
      end

      def quote
        @quote
      end

      def user_uid
        @user_uid
      end

      def valid?
        return false if quote.nil? || quote.empty?
        return false if quote[:uid].nil? || !quote[:uid].kind_of?(Integer)

        [quote[:added_by], quote[:content], quote[:publication_uid]].each do |required|
          return false if required.nil? || required.to_s.empty?
        end
        true
      end

    end
  end
end
