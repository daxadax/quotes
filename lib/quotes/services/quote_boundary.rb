require 'bound'

module Quotes
  module Services
    class QuoteBoundary < Service

      Quote = Bound.required(
        :uid,
        :added_by,
        :content,
        :publication_uid,
        :page_number,
        :tags,
        :links
      )

      def for(quote)
        build_boundary(quote)
      end

      private

      def build_boundary(quote)
        Quote.new(
          :uid => quote.uid,
          :added_by => quote.added_by,
          :content => quote.content,
          :publication_uid => quote.publication_uid,
          :page_number => quote.page_number,
          :tags => quote.tags,
          :links => quote.links
        )
      end

    end
  end
end
