module Quotes
  module Tasks
    class ImportQuotes < Task

      def initialize(files = nil)
        input_files = determine_input(files)
        @files      = determine_file_types(input_files)
        @gateway    = Gateways::QuotesGateway.new
      end

      def run
        quotes        = import_quotes
        unique_quotes = remove_duplicates quotes

        add_to_gateway unique_quotes
      end

      private

      def import_quotes
        files.flat_map do |file_type, file|
          build_quotes(file_type, file)
        end
      end

      def build_quotes(file_type, file)
        parser = determine_parser(file_type)

        parser.import(file)
      end

      def remove_duplicates(quotes)
        quotes.uniq { |quote| quote.content }
      end

      def add_to_gateway(quotes)
        quotes.each do |quote|
          @gateway.add(quote)
        end
      end

      def files
        @files
      end

    end
  end
end