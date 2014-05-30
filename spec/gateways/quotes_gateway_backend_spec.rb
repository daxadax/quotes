require 'spec_helper'

class QuotesGatewayBackendSpec < BackendSpec

  let(:backend) { Gateways::QuotesGatewayBackend.new }
  let(:quote)   { build_serialized_quote }
  let(:quote_with_tags) do
    build_serialized_quote(:tags => ['a', 'b', 'c'])
  end
  let(:persisted_quote_with_tags) do
    build_serialized_quote(:id => 1, :tags => ['a', 'b', 'c'])
  end

  describe "insert" do
    it "ensures the added object is a Quote Entity" do
      assert_failure { backend.insert(23) }
    end

    describe "with an already added quote" do
      let(:quote) { build_serialized_quote(:id => "already_here!") }

      it "fails" do
        assert_failure { backend.insert(quote) }
      end
    end

    it "returns the id of the inserted quote on success" do
      quote_id = backend.insert(quote)

      assert_equal 1, quote_id
    end
  end

  describe "get" do
    it "returns nil if the the quote is not persisted" do
      assert_nil backend.get(23)
    end

    it "stores the serialized data in database" do
      backend.insert(quote_with_tags)
      result = backend.get(1)

      assert_storage(result)
    end
  end

  describe "update" do
    describe "without a persisted quote" do
      it "fails" do
        assert_failure { backend.update(quote) }
      end
    end

    it "updates any changed attributes" do
      backend.insert(quote)
      backend.update(persisted_quote_with_tags)
      result = backend.get(1)

      refute_equal quote, result
      assert_storage(result)
    end
  end

  describe "all" do
    it "returns an empty array if the backend is empty" do
      assert_empty backend.all
    end

    it "returns all items in the backend" do
      backend.insert(quote)
      backend.insert(quote_with_tags)
      result = backend.all

      assert_equal 2,                       result.size
      assert_equal quote[:tags],            result[0][:tags]
      assert_equal quote_with_tags[:tags],  result[1][:tags]
    end
  end

  describe "delete" do
    it "removes the quote associated with the given id" do
      backend.insert(quote)
      backend.delete(1)

      assert_nil backend.get(1)
    end

    it "doesn't remove other quotes" do
      backend.insert(quote)
      backend.insert(quote_with_tags)
      backend.delete(1)

      assert_nil    backend.get(1)
      assert_equal  backend.get(2), quote_with_tags.merge({:id => 2})
    end
  end

  def assert_storage(actual)
    assert_equal quote_with_tags[:author],      actual[:author]
    assert_equal quote_with_tags[:title],       actual[:title]
    assert_equal quote_with_tags[:content],     actual[:content]
    assert_equal quote_with_tags[:publisher],   actual[:publisher]
    assert_equal quote_with_tags[:year],        actual[:year]
    assert_equal quote_with_tags[:page_number], actual[:page_number]
    assert_equal quote_with_tags[:tags],        actual[:tags]
  end

end