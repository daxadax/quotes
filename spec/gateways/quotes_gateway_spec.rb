require 'spec_helper'

class QuotesGatewaySpec < Minitest::Spec

  let(:backend) { FakeBackend.new }
  let(:gateway) { Gateways::QuotesGateway.new(backend) }
  let(:quote) { build_quote }
  let(:updated_quote) do
    build_quote(
      :uid         => "test_quote_uid",
      :links      => [24, 36]
    )
  end
  let(:add_quote) { gateway.add(quote) }

  describe "add" do
    it "ensures the added object is a Quote Entity" do
      assert_failure { gateway.add(23) }
    end

    describe "with an already added quote" do
      let(:quote) { build_quote(:uid => "already_here!") }

      it "fails" do
        assert_failure { gateway.add(quote) }
      end
    end

    it "returns the uid of the inserted quote on success" do
      quote_uid = add_quote

      assert_equal 'test_quote_uid', quote_uid
    end

    it "serializes the quote and delegates it to the backend" do
      quote_uid = add_quote
      result = gateway.get(quote_uid)

      assert_equal result.added_by, quote.added_by
      assert_equal result.content, quote.content
      assert_equal result.publication_uid, quote.publication_uid
    end

    describe "with tags" do
      let(:tags)  { ['UPCASE', 'CraZYcASe', 'downcase'] }
      let(:quote) { build_quote(:tags => tags) }

      it "normalizes tags before storing them" do
        quote_uid = add_quote
        result = gateway.get(quote_uid)

        refute_equal tags,        result.tags
        assert_equal 'upcase',    result.tags[0]
        assert_equal 'crazycase', result.tags[1]
        assert_equal 'downcase',  result.tags[2]
      end
    end
  end

  describe "get" do
    it "returns nil if the backend returns nil" do
      assert_nil gateway.get('not_a_stored_uid')
    end
  end

  describe "update" do

    describe "without a persisted object" do
      it "fails" do
        assert_failure { gateway.update(quote) }
      end
    end

    it "updates any changed attributes" do
      quote_uid = add_quote
      gateway.update(updated_quote)
      result = gateway.get(quote_uid)

      refute_equal quote, result
      assert_equal quote_uid, result.uid
      assert_equal quote.content, result.content
      assert_equal result.publication_uid, quote.publication_uid
      assert_equal quote.tags, result.tags
      assert_equal [24, 36], result.links
    end

  end

  describe "all" do
    let(:quote_two)   { build_quote(:content => "different") }
    let(:quote_three) { build_quote(:content => "something else") }
    let(:quotes)      { [quote, quote_two, quote_three] }

    it "returns an empty array if the backend is empty" do
      assert_empty gateway.all
    end

    it "returns all items in the backend" do
      quotes.each {|q| gateway.add(q)}
      result = gateway.all

      assert_equal 3, result.size
      assert_equal "Content", result[0].content
      assert_equal "different", result[1].content
      assert_equal "something else", result[2].content
    end
  end

  describe "delete" do
    describe "without a persisted object" do
      it "fails" do
        assert_failure { gateway.delete(quote.uid) }
      end
    end

    it "removes the quote associated with the given uid" do
      uid = gateway.add(quote)
      gateway.delete(uid)

      assert_nil gateway.get(uid)
    end
  end

  class FakeBackend

    def initialize
      @memory = []
    end

    def insert(quote)
      quote[:uid] = 'test_quote_uid'

      @memory << quote

      quote[:uid]
    end

    def get(uid)
      @memory.select{ |q| q[:uid] == uid}.first
    end

    def update(quote)
      @memory.delete_if {|q| q[:uid] == quote[:uid]}
      @memory << quote
    end

    def all
      @memory
    end

    def delete(uid)
      @memory.delete_if {|q| q[:uid] == uid}
    end

  end
end
