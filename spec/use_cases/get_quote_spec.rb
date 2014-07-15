require 'spec_helper'

class GetQuoteSpec < UseCaseSpec

  let(:quote)     { create_quote }
  let(:input)     { {:id => quote.id} }
  let(:use_case)  { UseCases::GetQuote.new(input) }

  describe "call" do
    let(:result) { use_case.call }

    describe "with unexpected input" do
      let(:quote) { build_quote }

      it "fails" do
        assert_failure { result }
      end
    end

    it "retrieves the quote with the given quote_id as a bound object" do
      assert_kind_of UseCases::GetQuote::Result, result

      assert_equal quote.id,      result.quote.id
      assert_equal quote.author,  result.quote.author
      assert_equal quote.title,   result.quote.title
      assert_equal quote.content, result.quote.content
    end
  end

end