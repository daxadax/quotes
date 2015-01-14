module Quotes
  module Tasks
    class ImportQuotes < Task

      def initialize(user_uid, input)
        validate input

        @user_uid = user_uid
        @input = input
      end

      def run
        import_unique_quotes
      end

      private

      def import_unique_quotes
        quotes = parse input

        add_to_gateway quotes
      end

      def remove_duplicates(quotes)
        quotes.uniq { |quote| quote.content }
      end

      def add_to_gateway(quotes)
        quotes.each do |quote|
          next if duplicate?(quote)
          gateway.add(quote)
        end
      end

      def duplicate?(new_quote)
        duplicate = gateway.all.detect do |persisted_quote|
          persisted_quote.author == new_quote.author &&
          persisted_quote.title == new_quote.title &&
          string_diff(persisted_quote, new_quote) <= 0.1
        end

        return true if duplicate
        false
      end

      def string_diff(original, new_string)
        original = original.content.split(' ')
        new_string = new_string.content.split(' ')

        (original - new_string).size / original.size.to_f
      end

      def parse(input)
        Services::KindleImporter.new(user_uid, input).import
      end

      def validate(input)
        msg = "Not a valid kindle clippings file"
        raise ArgumentError, msg unless input.start_with?("==")
      end

      def user_uid
        @user_uid
      end

      def input
        @input
      end

      def gateway
        @gateway ||= Gateways::QuotesGateway.new
      end

    end
  end
end
