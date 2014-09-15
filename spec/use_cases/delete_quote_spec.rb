require 'spec_helper'

class DeleteQuoteSpec < UseCaseSpec

  let(:input)       { {:id => quote_id} }
  let(:use_case)    { UseCases::DeleteQuote.new(input) }

  describe "call" do
    describe "with unexpected input" do
      let(:quote_id) { '23' }

      it "fails" do
        assert_failure { use_case.call }
      end
    end

    describe "with expected input" do
      before do
        5.times { create_quote }
      end

      let(:quote_id) { gateway.all.last.id }

      it "deletes the quote with the given quote_id" do
        assert_equal 5, gateway.all.count

        use_case.call

        assert_equal 4, gateway.all.count
        assert_nil gateway.get(quote_id)
      end
    end

  end

end