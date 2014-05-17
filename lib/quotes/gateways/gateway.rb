module Gateways
  class Gateway
    include Support::ValidationHelpers

    def backend_for_quotes
      raise "NO BACKEND YET!"
    end

    private

    def ensure_valid!(quote)
      ensure_kind_of!(quote)
      ensure_not_persisted!(quote)
    end

  end
end