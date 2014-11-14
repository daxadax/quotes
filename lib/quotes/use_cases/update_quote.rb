module Quotes
  module UseCases
    class UpdateQuote < UseCase

      Result = Bound.required(:error, :uid)

      def initialize(input)
        @quote = input[:quote]
      end

      def call
        return Result.new(:error => :invalid_input, :uid => nil) unless valid?

        Result.new(:error => nil, :uid => update_quote)
      end

      private

      def update_quote
        update_in_gateway build_quote
      end

      def build_quote
        added_by = quote.delete(:added_by)
        content = quote.delete(:content)
        publication_uid = quote.delete(:publication_uid)
        options = quote

        Entities::Quote.new(added_by, content, publication_uid, options)
      end

      def update_in_gateway(quote)
        quotes_gateway.update quote
      end

      def quote
        @quote
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
