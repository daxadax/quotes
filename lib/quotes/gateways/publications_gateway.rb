module Quotes
  module Gateways
    class PublicationsGateway < Gateway

      def initialize(backend = nil)
        @backend = backend || backend_for_publications
        @marshal = PublicationMarshal
      end

      def add(publication)
        ensure_valid!(publication)

        @backend.insert(serialized(publication))
      end

      def get(uid)
        deserialize(@backend.get(uid))
      end

      def all
        @backend.all.map do |publication|
          deserialize(publication)
        end
      end

      def update(publication)
        ensure_persisted!(publication.uid, 'update', 'publication')

        @backend.update(serialized(publication))
      end

      def delete(uid)
        ensure_persisted!(uid, 'delete', 'publication')

        @backend.delete(uid)
      end

      private

      def marshal
        @marshal
      end

      class PublicationMarshal

        def self.dump(publication)
          {
            :uid => publication.uid,
            :author => publication.author,
            :title => publication.title,
            :publisher => publication.publisher,
            :year => publication.year
          }
        end

        def self.load(publication)
          return nil unless publication

          author = publication[:author]
          title = publication[:title]
          publisher = publication[:publisher]
          year = publication[:year]
          uid = publication[:uid]

          Entities::Publication.new(author, title, publisher, year, uid)
        end

      end


    end
  end
end