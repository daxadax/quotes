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

    it "retrieves the quote with the given quote_id" do
      assert_equal quote.id,      result.id
      assert_equal quote.author,  result.author
      assert_equal quote.title,   result.title
      assert_equal quote.content, result.content
    end
  end

end