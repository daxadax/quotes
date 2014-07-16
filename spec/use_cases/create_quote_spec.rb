require 'spec_helper'

class CreateQuoteSpec < UseCaseSpec

  let(:quote)     { build_serialized_quote(:no_json => true) }
  let(:input)     { {:quote => quote} }
  let(:use_case)  { UseCases::CreateQuote.new(input) }

  describe "call" do
    let(:result)        { use_case.call }
    let(:loaded_quote)  { gateway.get(result.id) }

    describe "with unexpected input" do
      describe "without author" do
        before { quote.delete(:author) }

        it "fails" do
          assert_kind_of UseCases::CreateQuote::Failure, result
        end
      end

      describe "without title" do
        before { quote.delete(:title) }

        it "fails" do
          assert_kind_of UseCases::CreateQuote::Failure, result
        end
      end

      describe "without content" do
        before { quote.delete(:content) }

        it "fails" do
          assert_kind_of UseCases::CreateQuote::Failure, result
        end
      end

      describe "with no input" do
        let(:quote) { nil }

        it "fails" do
          assert_kind_of UseCases::CreateQuote::Failure, result
        end
      end
    end

    it "builds a new quote and saves it to the database" do
      assert_kind_of UseCases::CreateQuote::Success, result

      assert_equal 1,         loaded_quote.id
      assert_equal 'Author',  loaded_quote.author
      assert_equal 'Title',   loaded_quote.title
      assert_equal 'Content', loaded_quote.content
      assert_equal false,     loaded_quote.starred
    end

    it "returns the id of the newly created quote on success" do
      assert_equal 1, result.id
    end

  end


end