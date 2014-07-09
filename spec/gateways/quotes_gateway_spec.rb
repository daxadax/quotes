require 'spec_helper'

class QuotesGatewaySpec < Minitest::Spec

  let(:backend)   { FakeBackend.new }
  let(:gateway)   { Gateways::QuotesGateway.new(backend) }
  let(:quote)     { build_quote }
  let(:updated_quote) do
    build_quote(
      :author     => "New Author",
      :id         => "test_quote_id",
      :starred    => true,
      :links      => [24, 36]
    )
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

      assert_equal result.author,   quote.author
      assert_equal result.title,    quote.title
      assert_equal result.content,  quote.content
    end

    describe "with tags" do
      let(:tags)  { ['UPCASE', 'CraZYcASe', 'downcase'] }
      let(:quote) { build_quote(:tags => tags) }

      it "normalizes tags before storing them" do
        quote_id  = add_quote
        result    = gateway.get(quote_id)

        refute_equal tags,        result.tags
        assert_equal 'upcase',    result.tags[0]
        assert_equal 'crazycase', result.tags[1]
        assert_equal 'downcase',  result.tags[2]
      end
    end
  end

  describe "get" do
    it "returns nil if the backend returns nil" do
      assert_nil gateway.get('not_a_stored_id')
    end
  end

  describe "update" do

    describe "without a persisted object" do
      it "fails" do
        assert_failure { gateway.update(quote) }
      end
    end

    it "updates any changed attributes" do
      quote_id = add_quote
      gateway.update(updated_quote)
      result = gateway.get(quote_id)

      refute_equal quote,         result
      assert_equal quote_id,      result.id
      assert_equal 'New Author',  result.author
      assert_equal quote.title,   result.title
      assert_equal quote.content, result.content
      assert_equal true,          result.starred
      assert_equal quote.tags,    result.tags
      assert_equal [24, 36],      result.links
    end

  end

  describe "all" do
    let(:quote_two)   { build_quote(:author => "someone_else") }
    let(:quote_three) { build_quote(:author => "another_one") }
    let(:quotes)      { [quote, quote_two, quote_three] }

    it "returns an empty array if the backend is empty" do
      assert_empty gateway.all
    end

    it "returns all items in the backend" do
      quotes.each {|q| gateway.add(q)}
      result = gateway.all

      assert_equal 3,               result.size
      assert_equal "Author",        result[0].author
      assert_equal "someone_else",  result[1].author
      assert_equal "another_one",   result[2].author
    end
  end

  describe "delete" do
    describe "without a persisted object" do
      it "fails" do
        assert_failure { gateway.delete(quote.id) }
      end
    end

    it "removes the quote associated with the given id" do
      id = gateway.add(quote)
      gateway.delete(id)

      assert_nil gateway.get(id)
    end
  end

  class FakeBackend

    def initialize
      @memory = []
    end

    def insert(quote)
      quote[:id] = 'test_quote_id'

      @memory << quote

      quote[:id]
    end

    def get(id)
      @memory.select{ |q| q[:id] == id}.first
    end

    def update(quote)
      @memory.delete_if {|q| q[:id] == quote[:id]}
      @memory << quote
    end

    def all
      @memory
    end

    def delete(id)
      @memory.delete_if {|q| q[:id] == id}
    end

  end
end