require 'spec_helper'

class UpdateQuoteSpec < UseCaseSpec

  let(:options) do
    {
      :uid       => 1,
      :author   => 'updated author',
      :content  => 'updated content',
      :tags     => ['some', 'updated', 'tags'],
      :no_json  => true
    }
  end
  let(:quote)     { build_serialized_quote(options) }
  let(:input)     { {:quote => quote} }
  let(:use_case)  { UseCases::UpdateQuote.new(input) }

  describe "call" do
    let(:result)        { use_case.call }
    let(:loaded_quote)  { gateway.get(result.uid) }

    describe "with unexpected input" do
      describe "without author" do
        before { quote.delete(:author) }

        it "fails" do
          assert_kind_of UseCases::UpdateQuote::Failure, result
        end
      end

      describe "without title" do
        before { quote.delete(:title) }

        it "fails" do
          assert_kind_of UseCases::UpdateQuote::Failure, result
        end
      end

      describe "without content" do
        before { quote.delete(:content) }

        it "fails" do
          assert_kind_of UseCases::UpdateQuote::Failure, result
        end
      end

      describe "with no input" do
        let(:quote) { nil }

        it "fails" do
          assert_kind_of UseCases::UpdateQuote::Failure, result
        end
      end
    end

    describe "with correct input" do
      before { create_quote }

      it "updates the given quote" do
        assert_kind_of UseCases::UpdateQuote::Success, result

        assert_equal 1,                 loaded_quote.uid
        assert_equal 'updated author',  loaded_quote.author
        assert_equal 'Title',           loaded_quote.title
        assert_equal 'updated content', loaded_quote.content
        assert_equal false,             loaded_quote.starred
        assert_equal 3,                 loaded_quote.tags.size
      end

      it "returns the uid of the updated quote on success" do
        assert_equal 1, result.uid
      end
    end

  end


end