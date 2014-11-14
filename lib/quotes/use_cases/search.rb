module Quotes
  module UseCases
    class Search < UseCase

      Quote   = Services::QuoteBoundary::Quote
      Result  = Bound.required(
        :query,
        :tags,
        :quotes => [Quote]
      )

      def initialize(input)
        @query = input[:query]
      end

      def call
        return build_result([]) if blank_query

        build_result(search_results)
      end

      private

      def build_result(quotes)
        Result.new(
          :quotes => build_boundaries_from(quotes),
          :query  => query,
          :tags   => tags
        )
      end

      def build_boundaries_from(quotes)
        quotes.map do |quote|
          quote_boundary.for(quote)
        end
      end

      def search_results
        result = []
        searchable_quotes.each do |quote|
          result << quote if quote.content.match(/#{query}/i)
        end
        result
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

      def blank_query
        query.nil? || query.empty?
      end

      def publications
        @__publications ||= publications_gateway.all
      end

      def quotes
        @__quotes ||= quotes_gateway.all
      end

      def query
        @query_without_tags ||= @query.sub(/\[.*\]/, '').strip
      end

    end
  end
end
