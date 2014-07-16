require 'bound'

module Quotes
  module UseCases
    class UpdateQuote < UseCase

      Success = Bound.required(:id)
      Failure = Bound.new

      def initialize(input)
        @quote = input[:quote]
      end

      def call
        return Failure.new if invalid?

        Success.new(:id => update_quote )
      end

      private

      def update_quote
        quote = build_quote
        add_to_gateway quote
      end

      def build_quote
        author  = quote.delete(:author)
        title   = quote.delete(:title)
        content = quote.delete(:content)
        options = quote

        Entities::Quote.new(author, title, content, options)
      end

      def add_to_gateway(quote)
        gateway.update quote
      end

      def quote
        @quote
      end

      def invalid?
        return true if quote.nil? || quote.empty?
        return true if quote[:id].nil? || !quote[:id].kind_of?(Integer)

        [quote[:author], quote[:title], quote[:content]].each do |required|
          return true if required.nil? || required.empty?
        end
        false
      end

    end
  end
end