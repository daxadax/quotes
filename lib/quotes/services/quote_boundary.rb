require 'bound'

module Quotes
  module Services
    class QuoteBoundary < Service

      Quote = Bound.required(
        :uid,
        :author,
        :title,
        :content,
        :publisher,
        :year,
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
          :uid           => quote.uid,
          :author       => quote.author,
          :title        => quote.title,
          :content      => quote.content,
          :publisher    => quote.publisher,
          :year         => quote.year,
          :page_number  => quote.page_number,
          :tags         => quote.tags,
          :links        => quote.links
        )
      end

    end
  end
end