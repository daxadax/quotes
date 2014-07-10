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

      def update(quote)
        ensure_persisted!(quote.id, 'update')

        @backend.update(serialized(quote))
      end

      def all
        @backend.all.map do |quote|
          deserialize(quote)
        end
      end

      def delete(id)
        ensure_persisted!(id, 'delete')

        @backend.delete(id)
      end

      def toggle_star(id)
        ensure_persisted!(id, 'toggle the star status of')

        @backend.toggle_star(id)
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

      def ensure_persisted!(id, action)
        reason = "You tried to #{action} a quote, but it doesn't exist"

        raise_argument_error(reason, 'None.  ID is nil') if id.nil?
      end

      class QuoteMarshal

        def self.dump(quote)
          tags = quote.tags.map(&:downcase)

          {
            :id           => quote.id,
            :author       => quote.author,
            :title        => quote.title,
            :content      => quote.content,
            :publisher    => quote.publisher,
            :year         => quote.year,
            :page_number  => quote.page_number,
            :starred      => quote.starred,
            :tags         => JSON.dump(tags),
            :links        => JSON.dump(quote.links)
          }
        end

        def self.load(quote)
          return nil unless quote

          author  = quote[:author]
          title   = quote[:title]
          content = quote[:content]
          options = {
            :id           => quote[:id],
            :publisher    => quote[:publisher],
            :year         => quote[:year],
            :page_number  => quote[:page_number],
            :starred      => quote[:starred],
            :tags         => JSON.parse(quote[:tags]),
            :links        => JSON.parse(quote[:links])
          }

          Entities::Quote.new(author, title, content, options)
        end

      end

    end
  end
end