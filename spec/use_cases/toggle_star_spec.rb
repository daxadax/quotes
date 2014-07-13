require 'spec_helper'

class ToggleStarSpec < UseCaseSpec

  let(:quote)           { create_quote }
  let(:starred_quote)   { create_quote(:starred => true) }
  let(:updated_quote)   { gateway.get(quote.id) }
  let(:updated_starred) { gateway.get(starred_quote.id) }
  let(:input) do
    {
      :id  => quote.id,
    }
  end
  let(:use_case)  { UseCases::ToggleStar.new(input) }

  describe "call" do

    describe "with unexpected input" do
      let(:quote) { build_quote }

      it "fails" do
        assert_failure { use_case.call }
      end
    end

    it "toggles 'starred' for the given quote" do
      assert_equal false, quote.starred
      use_case.call

      assert_equal true,  updated_quote.starred
    end
  end

end