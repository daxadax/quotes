require 'spec_helper'

class UpdateQuoteSpec < UseCaseSpec

  let(:options) do
    {
      :uid       => 1,
      :content  => 'updated content',
      :publication_uid => 1000,
      :tags     => ['some', 'updated', 'tags'],
      :no_json  => true
    }
  end
  let(:quote) { build_serialized_quote(options) }
  let(:input) { {:quote => quote} }
  let(:use_case) { UseCases::UpdateQuote.new(input) }

  describe "call" do
    let(:result) { use_case.call }
    let(:loaded_quote) { quotes_gateway.get(result.uid) }

    describe "with unexpected input" do

      describe "without uid" do
        before { quote.delete(:uid) }

        it "fails" do
          assert_equal :invalid_input, result.error
          assert_nil result.uid
        end
      end

      describe "without added_by" do
        before { quote.delete(:added_by) }

        it "fails" do
          assert_equal :invalid_input, result.error
          assert_nil result.uid
        end
      end

      describe "without content" do
        before { quote.delete(:content) }

        it "fails" do
          assert_equal :invalid_input, result.error
          assert_nil result.uid
        end
      end

      describe "without publication_uid" do
        before { quote.delete(:publication_uid) }

        it "fails" do
          assert_equal :invalid_input, result.error
          assert_nil result.uid
        end
      end

      describe "with no input" do
        let(:quote) { nil }

        it "fails" do
          assert_equal :invalid_input, result.error
          assert_nil result.uid
        end
      end
    end

    describe "with correct input" do
      before { create_quote }

      it "returns the uid of the updated quote on success" do
        assert_nil result.error
        assert_equal 1, result.uid
      end

      it "updates the given quote" do
        assert_equal 1, loaded_quote.uid
        assert_equal 23, loaded_quote.added_by
        assert_equal 'updated content', loaded_quote.content
        assert_equal 1000, loaded_quote.publication_uid
        assert_equal 3, loaded_quote.tags.size
      end
    end

  end


end
