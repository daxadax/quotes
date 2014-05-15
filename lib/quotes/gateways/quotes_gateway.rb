module Gateways
  class QuotesGateway < Gateway

    def initialize(db_file = nil)
      @db_file = db_file || quotes_db_file
    end

    def add(quotes)
      ensure_validity(quotes)

      add_quotes_to_file merge_and_serialize(quotes)
    end

    def all
      load_all
    end

    private

    def add_quotes_to_file(serialized_quotes)
      persist(serialized_quotes)
    end

    def load_all
      return [] unless quotes_persisted?

      Marshal.load(db_file_content)
    end

    def persist(quotes)
      File.open(@db_file, 'w') do |f|
        f.write(quotes)
      end
    end

    def merge_and_serialize(quotes)
      quotes = merge(quotes) if quotes_persisted?

      Marshal.dump(quotes)
    end

    def merge(quotes)
      (load_all + quotes).uniq { |q| q.content }
    end

    def ensure_validity(quotes)
      quotes.each do |quote|
        msg = "Only Excerpt entities can be inserted."

        raise_argument_error(msg, quote) unless quote.kind_of? Entities::Excerpt
      end
    end

    def quotes_persisted?
      db_file_content.length > 0
    end

    def db_file_content
      File.read(@db_file)
    end

  end
end
