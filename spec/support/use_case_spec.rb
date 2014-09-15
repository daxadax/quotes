require 'spec_helper'

class UseCaseSpec < Minitest::Spec

  def gateway
    @gateway ||= Gateways::QuotesGateway.new
  end

end