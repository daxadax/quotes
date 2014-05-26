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

  describe "get_by_tag" do
    let(:quote_one) { build_quote(:tags => ['omg', 'lol', 'srsly']) }
    let(:quote_two) { build_quote(:tags => ['omg', 'stfu']) }
    let(:quotes)    { [quote_one, quote_two] }

    before do
      quotes.each {|q| gateway.add(q)}
    end

    it "returns an empty array if their are no quotes for the tag" do
      result = gateway.get_by_tag('wtf')

      assert_empty result
    end

    it "returns an array quotes with matching tags" do
      result = gateway.get_by_tag('omg')

      assert_equal 2,                       result.size
      assert_equal ['omg', 'lol', 'srsly'], result[0].tags
      assert_equal ['omg', 'stfu'],         result[1].tags
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
      assert_equal 'New Author',  result.author
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
      @memory.select{|q| q[:id] == id}.first
    end

    def get_by_tag(tag)
      @memory.select{|q| q[:tags].include?(tag)}
    end

    def update(quote)
      @memory.delete_if {|q| q[:id] == quote[:id]}
      @memory << quote
    end

    def all
      @memory
    end

  end
end