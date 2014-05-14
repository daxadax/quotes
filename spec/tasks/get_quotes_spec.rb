require 'spec_helper'

class GetQuotesSpec < Minitest::Spec

  let(:input) do
    [
      File.read("spec/support/sample_kindle_clippings.txt"),
      File.read("spec/support/kindle_clippings_with_dups.txt"),
      File.read("spec/support/sample_wordpress_blog.xml")
    ]
  end

  let(:get_quotes)  { Tasks::GetQuotes.new(input) }

  describe "call" do

    before do
      get_result
    end

    describe "with no input" do
      let(:input) { [] }

      it "returns an empty array" do
        assert_empty @result
      end
    end

    describe "with input" do
      it "returns an array of excerpt entities" do
        assert_kind_of  Entities::Excerpt,  @result.first

      end

      it "does not return duplicates" do
        assert_equal 7, @result.size
      end
    end

  end

  def get_result
    @result ||= get_quotes.call
  end

end