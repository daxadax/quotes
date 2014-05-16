require 'spec_helper'

class ImportQuotesSpec < TaskSpec

  let(:files) do
    [
      File.read("spec/support/sample_kindle_clippings.txt"),
      File.read("spec/support/kindle_clippings_with_dups.txt"),
      File.read("spec/support/sample_wordpress_blog.xml")
    ]
  end
  let(:import_quotes) { Tasks::ImportQuotes.new(files) }

  describe "run" do
    let(:result) { import_quotes.run }

    describe "with no files" do
      let(:files) { [] }

      it "returns an empty array" do
        assert_empty result
      end
    end

    describe "with input" do
      it "returns a collection of quote entities" do
        assert_kind_of  Array,            result
        assert_kind_of  Entities::Quote,  result.first
      end

      it "does not return duplicates" do
        assert_equal 7, result.size
      end
    end

  end

end