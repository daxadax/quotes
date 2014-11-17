require 'support/fake_quotes_backend'
require 'support/fake_publications_backend'

class FakeGatewayAccess < MiniTest::Spec

  @@fake_for_pubs = Support::FakePublicationsBackend.new
  @@fake_for_quotes = Support::FakeQuotesBackend.new @@fake_for_pubs

  before do
    service_factory.register :quotes_backend do
      @@fake_for_quotes
    end

    service_factory.register :publications_backend do
      @@fake_for_pubs
    end
  end

  after do
    @@fake_for_quotes.reset
    @@fake_for_pubs.reset
  end

  def quotes_gateway
    Quotes::Gateways::QuotesGateway.new @@fake_for_quotes
  end

  def publications_gateway
    Quotes::Gateways::PublicationsGateway.new @@fake_for_pubs
  end

  def service_factory
    Quotes::ServiceFactory
  end

end
