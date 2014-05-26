module Quotes
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

      def get_by_tag(tag)
        @backend.get_by_tag(tag).map do |quote|
          deserialize(quote)
        end
      end

      def update(quote)
        ensure_persisted!(quote)

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

      def ensure_valid!(quote)
        ensure_kind_of!(quote)
        ensure_not_persisted!(quote)
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

      def ensure_persisted!(quote)
        reason = "Quotes must exist to update them. Use #insert instead"

        raise_argument_error(reason, quote) if quote.id.nil?
      end

      class QuoteMarshal

        def self.dump(quote)
          {
            :author       => quote.author,
            :title        => quote.title,
            :content      => quote.content,
            :publisher    => quote.publisher,
            :year         => quote.year,
            :page_number  => quote.page_number,
            :tags         => JSON.dump(quote.tags),
            :id           => quote.id
          }
        end

        def self.load(quote)
          return nil unless quote

          author  = quote[:author]
          title   = quote[:title]
          content = quote[:content]
          options = {
            :publisher    => quote[:publisher],
            :year         => quote[:year],
            :page_number  => quote[:page_number],
            :tags         => JSON.parse(quote[:tags]),
            :id           => quote[:id]
          }

          Entities::Quote.new(author, title, content, options)
        end

      end

    end
  end
end