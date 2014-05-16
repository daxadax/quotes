module Gateways
  class QuotesGateway < Gateway

    def initialize(db_file = nil)
      @db_file  = db_file || quotes_db_file
      @uid = determine_last_uid
    end

    def add(quotes)
      ensure_validity! quotes

      add_quotes_to_file quotes
    end

    def all
      load_all
    end

    private

    def add_quotes_to_file(quotes)
      merged_quotes     = merge quotes
      quotes_with_uids  = assign_uids merged_quotes
      serialized_quotes = serialize quotes_with_uids

      persist serialized_quotes
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

    def serialize(quotes)
      Marshal.dump(quotes)
    end

    def assign_uids(quotes)
      quotes.each do |quote|
        assign_uid(quote) if quote.id.nil?
      end
    end

    def merge(quotes)
      (load_all + quotes).uniq do |quote|
        quote.content
      end
    end

    def assign_uid(quote)
      quote.id = return_next_id
    end

    def return_next_id
      @uid += 1
    end

    def ensure_validity!(quotes)
      quotes.each do |quote|
        msg = "Only Excerpt entities can be inserted."

        raise_argument_error(msg, quote) unless quote.kind_of? Entities::Excerpt
      end
    end

    def determine_last_uid
      return load_all.last.id if quotes_persisted?
      0
    end

    def quotes_persisted?
      db_file_content.length > 0
    end

    def db_file_content
      File.read(@db_file)
    end

  end
end
