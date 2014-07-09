module Quotes
  module Services
    class LinksUpdater < Service

      def update(id_one, id_two)
        run_updater(id_one, id_two)
        run_updater(id_two, id_one)
      end

      private

      def run_updater(quote_id, target)
        quote = gateway.get(quote_id)
        quote.update_links(target)
        gateway.update(quote)
      end

      def gateway
        @gateway ||= Gateways::QuotesGateway.new
      end

    end
  end
end