module Gateways
  class QuotesGateway < Gateway

    def initialize(backend = nil)
      @backend = backend || backend_for_quotes
    end

    def add(quote)
      ensure_valid!(quote)

      @backend.insert(serialized(quote))
    end

    def get(id)
      deserialize(@backend.get(id))
    end

    def update(quote)
      return nil if quote.id.nil?

      @backend.update(serialized(quote))
    end

    def all
      @backend.all.map do |quote|
        deserialize(quote)
      end
    end

    private

    def serialized(quote)
      QuoteMarshal.dump(quote)
    end

    def deserialize(quote)
      QuoteMarshal.load(quote)
    end

    def ensure_kind_of!(quote)
      reason = "Only Quote entities can be added"

      unless quote.kind_of? Entities::Quote
        raise_argument_error(reason, quote)
      end
    end

    def ensure_not_persisted!(quote)
      reason = "Quotes can't be added twice. Use #update instead"

      raise_argument_error(reason, quote) unless quote.id.nil?
    end

    class QuoteMarshal

      def self.dump(quote)
        {
          :author   => quote.author,
          :title    => quote.title,
          :content  => quote.content,
          :source   => quote.source,
          :tags     => quote.tags,
          :id       => quote.id
        }
      end

      def self.load(quote)
        return nil unless quote

        author  = quote[:author]
        title   = quote[:title]
        content = quote[:content]
        options = {
          :publisher    => quote[:source][:publisher],
          :year         => quote[:source][:year],
          :page_number  => quote[:source][:page_number],
          :tags         => quote[:tags],
          :id           => quote[:id]
        }

        Entities::Quote.new(author, title, content, options)
      end

    end

  end
end