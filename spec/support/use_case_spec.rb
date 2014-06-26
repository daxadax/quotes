require 'support/backend_spec'
require 'spec_helper'

class UseCaseSpec < BackendSpec

  def gateway
    @gateway ||= Gateways::QuotesGateway.new
  end

end