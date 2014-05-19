module Gateways
  class QuotesGatewayBackend < Backend

    def initialize
      super
      @table = @database[:quotes]
    end

    def insert(quote)
      ensure_valid!(quote)

      @table.insert(quote)
    end

    def get(id)
      @table.first(:id => id)
    end

    def update(quote)
      ensure_persisted!(quote)

      @table.where(:id => quote[:id]).update(quote)
    end

    def all
      @table.all
    end

    private

    def ensure_valid!(quote)
      ensure_kind_of!(quote)
      ensure_not_persisted!(quote)
    end

    def ensure_kind_of!(quote)
      reason = "Only Hashes can be inserted"

      unless quote.kind_of? Hash
        raise_argument_error(reason, quote)
      end
    end

    def ensure_not_persisted!(quote)
      reason = "Quotes can't be added twice. Use #update instead"

      raise_argument_error(reason, quote) unless quote[:id].nil?
    end

    def ensure_persisted!(quote)
      reason = "Quotes must exist to update them. Use #insert instead"

      raise_argument_error(reason, quote) if quote[:id].nil?
    end

  end
end