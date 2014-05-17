require 'spec_helper'

class QuotesGatewaySpec < Minitest::Spec

  let(:backend)   { FakeBackend.new }
  let(:gateway)   { Gateways::QuotesGateway.new(backend) }
  let(:quote)     { build_quote }
  let(:updated_quote) do
    build_quote(:author => "New Author", :id => "test_quote_id")
  end
  let(:add_quote) { gateway.add(quote) }

  describe "add" do
    it "ensures the added object is a Quote Entity" do
      assert_failure { gateway.add(23) }
    end

    describe "with an already added quote" do
      let(:quote) { build_quote(:id => "already_here!") }

      it "fails" do
        assert_failure { gateway.add(quote) }
      end
    end

    it "returns the id of the inserted quote on success" do
      quote_id = add_quote

      assert_equal 'test_quote_id', quote_id
    end

    it "serializes the quote and delegates it to the backend" do
      quote_id  = add_quote
      result    = gateway.get(quote_id)

      assert_equal result,          quote
      assert_equal result.author,   quote.author
      assert_equal result.title,    quote.title
      assert_equal result.content,  quote.content
    end
  end

  describe "get" do
    it "returns nil if the backend returns nil" do
      assert_nil gateway.get('not_a_stored_id')
    end
  end

  describe "update" do

    it "returns nil without a persisted object" do
      assert_nil gateway.update(quote)
    end

    it "updates any changed attributes" do
      quote_id = add_quote
      gateway.update(updated_quote)
      result = gateway.get(quote_id)

      refute_equal quote,         result
      assert_equal 'New Author',  result.author
    end

  end

  class FakeBackend

    def initialize
      @memory = []
    end

    def insert(quote)
      quote.id = 'test_quote_id'

      @memory << quote

      quote.id
    end

    def get(id)
      @memory.select{ |q| q.id == id}.first
    end

    def update(quote)
      return nil if quote.id.nil?

      @memory.delete_if {|q| q.id == quote.id}
      @memory << quote
    end

  end
end