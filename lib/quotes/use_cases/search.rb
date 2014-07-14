require 'bound'

module Quotes
  module UseCases
    class Search < UseCase

      Result = Bound.required(
        :quotes,
        :query,
        :tags
      )

      def initialize(input)
        @query = input[:query]
      end

      def call
        return build_result(searchable) if blank_query

        build_result(search_results)
      end

      private

      def build_result(search_results)
        Result.new(
          :quotes => search_results,
          :query  => query,
          :tags   => tags
        )
      end

      def search_results
        searchable.inject([]) do |result, quote|
          build_search_result(result, quote)
          result
        end
      end

      def build_search_result(result, quote)
        [ quote.author, quote.title, quote.content].any? do |q|
          result << quote if q.match(/#{query}/i)
        end
      end

      def searchable
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

      def quotes
        @quotes ||= gateway.all
      end

      def query
        @query_without_tags ||= @query.sub(/\[.*\]/, '').strip
      end

    end
  end
end