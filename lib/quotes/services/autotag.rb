module Quotes
  module Services
    class Autotag < Service

      def initialize(quote)
        @quote = quote
      end

      def run
        add_matching_tags
        gateway.update quote
      end

      private

      def add_matching_tags
        current_tags.each do |tag|
          if quote.content =~ /\b(#{Regexp.quote(tag)}\b)/i
            quote.tags << tag
          end
        end
      end

      def quote
        @quote
      end

      def current_tags
        gateway.all.flat_map(&:tags).uniq
      end

      def gateway
        @gateway ||= Gateways::QuotesGateway.new
      end

    end
  end
end
