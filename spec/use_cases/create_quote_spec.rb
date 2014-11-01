require 'spec_helper'

class CreateQuoteSpec < UseCaseSpec

  let(:quote) { build_serialized_quote(:no_json => true) }
  let(:input) do
    {
      :user_uid => 1,
      :quote => quote
    }
  end
  let(:use_case) { UseCases::CreateQuote.new(input) }

  describe "call" do
    let(:result)        { use_case.call }
    let(:loaded_quote)  { gateway.get(result.uid) }

    describe "with unexpected input" do
      describe 'with no user_uid' do
        before { input.delete(:user_uid) }

        it "fails" do
          assert_equal :invalid_input, result.error
          assert_nil result.uid
        end
      end

      describe "with no quote" do
        before { input.delete(:quote) }

        it "fails" do
          assert_equal :invalid_input, result.error
          assert_nil result.uid
        end
      end

      describe "without author" do
        before { quote.delete(:author) }

        it "fails" do
          assert_equal :invalid_input, result.error
          assert_nil result.uid
        end
      end

      describe "without title" do
        before { quote.delete(:title) }

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
    end

    it "builds a new quote and saves it to the database" do
      assert_nil result.error

      assert_equal 1,         loaded_quote.uid
      assert_equal 1,         loaded_quote.added_by
      assert_equal 'Author',  loaded_quote.author
      assert_equal 'Title',   loaded_quote.title
      assert_equal 'Content', loaded_quote.content
    end

    it "returns the uid of the newly created quote on success" do
      assert_nil result.error
      assert_equal 1, result.uid
    end

  end


end
