module Tasks
  class GetQuotes < Task

    def initialize(input = nil, gateway = nil)
      input_files = determine_input(input)
      @files      = determine_file_types(input_files)
      @gateway    = gateway #|| Gateways::QuotesGateway.new
    end

    def run
      quotes = remove_duplicates(get_quotes)

      gateway.add quotes
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

    def gateway
      @gateway
    end

  end
end