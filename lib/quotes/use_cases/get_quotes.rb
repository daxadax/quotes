module UseCases
  class GetQuotes < UseCase

    def initialize(input)
      @files = determine_file_types(input)
    end

    def call
      quotes = get_quotes

      remove_duplicates(quotes)
    end

    private

    def get_quotes
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

    def files
      @files
    end

  end
end