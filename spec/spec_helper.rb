require 'minitest/autorun'

$LOAD_PATH.unshift('lib', 'spec')

# require all support files
Dir.glob('./spec/support/*.rb')  { |f| require f }

require 'quotes'
ENV['test'] = '1'

class Minitest::Spec
  include Support::AssertionHelpers
  include Support::FactoryHelpers
  include Quotes


  end

  end

  def quotes_gateway
    Quotes::Gateways::QuotesGateway.new @@fake_quotes_backend
  end

  def publications_gateway
    Quotes::Gateways::PublicationsGateway.new @@fake_publications_backend
  end


end
