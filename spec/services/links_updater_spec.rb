require 'spec_helper'

class LinksUpdaterSpec < ServiceSpec
  let(:gateway)         { Gateways::QuotesGateway.new }
  let(:links_updater)   { Services::LinksUpdater.new }
  let(:linked_quote)    { create_quote }
  let(:quote)           { create_quote }

  describe "update" do
    before            { links_updater.update(quote.id, linked_quote.id) }
    let(:result_one)  { gateway.get(quote.id) }
    let(:result_two)  { gateway.get(linked_quote.id) }

    describe "with no link between the quotes" do
      it "adds a link" do
        assert_includes result_one.links,  linked_quote.id
        assert_includes result_two.links,  quote.id
      end
    end

    describe "with a link already present between the quotes" do
      before { links_updater.update(quote.id, linked_quote.id) }

      it "removes the link" do
        assert_empty result_one.links
        assert_empty result_two.links
      end

    end
  end

end