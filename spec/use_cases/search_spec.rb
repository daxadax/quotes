require 'spec_helper'

class SearchSpec < UseCaseSpec

  let(:query) { '' }
  let(:input) do
    { :query  => query }
  end
  let(:use_case)  { UseCases::Search.new(input) }

  before { create_quotes_for_test }

  describe "call" do
    let(:result) { use_case.call }

    it 'returns a boundary object' do
      assert_kind_of UseCases::Search::Result, result
    end

    describe "with no query" do
      it "returns an empty array" do
        assert_empty result.quotes
      end
    end

    describe "text search" do
      let(:query) { 'author 25' }

      it "flag returns results for the given query" do
        assert_equal 'author 25', result.query
        assert_empty result.tags
        assert_equal 1, result.publications.size
        assert_equal 1, result.quotes.size
      end

      describe "text from tags" do
        let(:query) { '[author 23]' }

        it 'is not included in the text search' do
          assert_empty result.query
          assert_equal ['author 23'], result.tags
          assert_equal 0, result.publications.size
          assert_equal 0, result.quotes.size
        end
      end
    end

    describe "tag search" do
      describe "with no matching tags" do
        let(:query) { '[nothing here]' }

        it "returns no results" do
          assert_empty result.query
          assert_equal ['nothing here'], result.tags
          assert_equal 0, result.publications.size
          assert_equal 0, result.quotes.size
        end
      end

      describe "with one tag" do
        let(:query) { '[tag_1]' }

        it "returns results with a matching tag" do
          assert_empty result.query
          assert_equal ['tag_1'], result.tags
          assert_equal 0, result.publications.size
          assert_equal 10, result.quotes.size

          result.quotes.each do |quote|
            assert_includes quote.tags, 'tag_1'
          end
        end
      end

      describe "with multiple tags" do
        let(:query) { '[tag_0] [two tags]' }

        it "returns results that have both tags" do
          assert_empty result.query
          assert_equal ['tag_0', 'two tags'], result.tags
          assert_equal 0, result.publications.size
          assert_equal 2, result.quotes.size
        end
      end

    end

    describe "text and tag search" do
      let(:query) { '[tag_0] [two tags] author 19' }

      it "returns results for the given query after filtering by tags" do
        assert_equal 'author 19', result.query
        assert_equal ['tag_0', 'two tags'], result.tags
        assert_equal 1, result.publications.size
        assert_equal 1, result.quotes.size
      end
    end
  end

  private

  def create_quotes_for_test
    @quotes ||= 50.times.map do |i|
      create_quote(build_options(i+1))
    end
  end

  def build_options(i)
    {
      :author => "Author #{i}",
      :title  => "Title #{i}",
      :tags   => [
        "tag_#{i}a",
        "tag_#{i}b",
        "tag_#{(i+1)%5}",
        conditional_tag(i+1)
      ]
    }
  end

  def conditional_tag(i)
    return 'two tags' if i%20 == 0
    ''
  end

end
