require 'bound'

module Quotes
  module Services
    class QuoteBoundary < Service

      Quote = Bound.required(
        :id,
        :author,
        :title,
        :content,
        :publisher,
        :year,
        :page_number,
        :starred,
        :tags,
        :links
      )

      def for(quote)
        build_boundary(quote)
      end

      private

      def build_boundary(quote)
        Quote.new(
          :id           => quote.id,
          :author       => quote.author,
          :title        => quote.title,
          :content      => quote.content,
          :publisher    => quote.publisher,
          :year         => quote.year,
          :page_number  => quote.page_number,
          :starred      => quote.starred,
          :tags         => quote.tags,
          :links        => quote.links
        )
      end

    end
  end
end