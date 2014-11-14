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

  after do
    @@fake_quotes_backend.reset
    @@fake_publications_backend.reset
  end

  service_factory = Quotes::ServiceFactory
  @@fake_quotes_backend ||=  ::Support::FakeBackend.new
  @@fake_publications_backend ||= ::Support::FakeBackend.new

  service_factory.register :quotes_backend do
    @@fake_quotes_backend
  end

  service_factory.register :publications_backend do
    @@fake_publications_backend
  end

  def quotes_gateway
    Quotes::Gateways::QuotesGateway.new @@fake_quotes_backend
  end

  def publications_gateway
    Quotes::Gateways::PublicationsGateway.new @@fake_publications_backend
  end


end
