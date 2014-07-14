require 'spec_helper'

class SearchSpec < UseCaseSpec
  let(:query) { '' }
  let(:input) do
    { :query  => query }
  end
  let(:use_case)  { UseCases::Search.new(input) }

  before { quotes }

  describe "call" do
    let(:result) { use_case.call }

    describe "with unexpected input" do
      it "returns all results unfiltered" do
        assert_equal 50, result.count
      end
    end

    describe "text search" do
      let(:query) { 'author 25' }

      it "returns results for the given query" do
        assert_equal 1, result.count

        assert_equal 'Author 25',         result[0].author
        assert_equal 'Title 25',          result[0].title
        assert_includes result[0].tags,  'tag_25a'
      end

      describe "does not include text from tags" do
        let(:query) { '[author 23]' }

        it { assert_empty result }
      end
    end

    describe "tag search" do
      describe "with no matching tags" do
        let(:query) { '[nothing here]' }

        it "returns an empty array" do
          assert_empty result
        end
      end

      describe "with one tag" do
        let(:query) { '[tag_1]' }

        it "returns results with a matching tag" do
          assert_equal 10, result.count

          result.each do |quote|
            assert_includes quote.tags, 'tag_1'
          end
        end
      end

      describe "with multiple tags" do
        let(:query) { '[tag_0] [two tags]' }

        it "returns results that have both tags" do
          assert_equal 2, result.count
        end
      end

    end

    describe "text and tag search" do
      let(:query) { '[tag_0] [two tags] author 19' }

      it "returns items with matching tags and text" do
        assert_equal 1, result.count

        assert_equal "Author 19", result[0].author
      end
    end
  end

  private

  def quotes
    @quotes ||= 50.times.map do |i|
      create_quote(build_options(i))
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