module Gateways
  class QuotesGateway < Gateway

    def initialize(backend = nil)
      @backend = backend || backend_for_quotes
    end

    def add(quote)
      ensure_valid!(quote)

      @backend.insert(quote)
    end

    def get(id)
      @backend.get(id)
    end

    def update(quote)
      @backend.update(quote)
    end

    def all
      @backend.all
    end

    private

    def ensure_valid!(quote)
      ensure_entity!(quote)
      ensure_not_persisted!(quote)
    end

    def ensure_entity!(quote)
      reason = "Only Quote entities can be added"

      unless quote.kind_of? Entities::Quote
        raise_argument_error(reason, quote)
      end
    end

    def ensure_not_persisted!(quote)
      reason = "Quotes can't be added twice. Use #update instead"

      raise_argument_error(reason, quote) unless quote.id.nil?
    end

  end
end