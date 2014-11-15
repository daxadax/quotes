module Quotes
  module UseCases
    class Search < UseCase

      Quote   = Services::QuoteBoundary::Quote
      Result  = Bound.required(
        :query,
        :tags,
        :publications,
        :quotes => [Quote]
      )

      def initialize(input)
        @query = input[:query]
      end

      def call
        build_result
      end

      private

      def build_result
        Result.new(
          :query  => query,
          :tags   => tags,
          :publications => publications_result,
          :quotes => build_boundaries_from(quotes_result),
        )
      end

      def build_boundaries_from(quotes)
        quotes.map do |quote|
          quote_boundary.for(quote)
        end
      end

      def quotes_result
        @quotes_result ||= search_quotes.uniq
      end

      def publications_result
        @publications_result ||= search_publications.uniq
      end

      def search_publications
        return [] if blank_query?

        @publications_result = publications.inject([]) do |result, publication|
          result << publication.uid if publication.author.match(/#{query}/i)
          result << publication.uid if publication.title.match(/#{query}/i)
          result
        end
      end

      def search_quotes
        return [] if tags.empty? && blank_query?
        return searchable_quotes if blank_query?

        searchable_quotes.inject([]) do |result, quote|
          result << quote if quote.content.match(/#{query}/i)
          result << quote if publications_result.include? quote.publication_uid
          result
        end
      end

      def searchable_quotes
        return quotes if tags.empty?
        quotes.select { |q| (q.tags & tags) == tags }
      end

      def tags
        @tags ||= @query.scan(/\[.*?\]/).map do |tag|
          tag.match(/\[(.*)\]/)[1]
        end
      end

      def blank_query?
        query.nil? || query.empty?
      end

      def publications
        @publications ||= publications_gateway.all
      end

      def quotes
        @quotes ||= quotes_gateway.all
      end

      def query
        @query_without_tags ||= @query.sub(/\[.*\]/, '').strip
      end

    end
  end
end
