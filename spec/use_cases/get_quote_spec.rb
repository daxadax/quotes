require 'spec_helper'

class GetQuoteSpec < UseCaseSpec

  let(:quote_id)    { create_quote }
  let(:input)       { {:id => quote_id} }
  let(:use_case)    { UseCases::GetQuote.new(input) }

  describe "call" do
    let(:result) { use_case.call }

    describe "with unexpected input" do
      let(:quote_id) { '23' }

      it "fails" do
        assert_failure { result }
      end
    end

    it "retrieves the quote with the given quote_id" do
      assert_equal quote_id,  result.id
      assert_equal 'Author',  result.author
      assert_equal 'Title',   result.title
      assert_equal 'Content', result.content
    end
  end

end