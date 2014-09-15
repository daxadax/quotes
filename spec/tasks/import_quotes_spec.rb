require 'spec_helper'

class ImportQuotesSpec < Minitest::Spec

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
      let(:result) { Gateways::QuotesGateway.new.all }
      before       { import_quotes.run }

      it "adds all quote entities to the gateway" do
        assert_kind_of  Array,                result
        assert_kind_of  Entities::Quote,      result.last
        assert_equal    'Erich Neumann',      result.last.author
        assert_includes result.last.content,  'archetypal stages'
        assert_equal    'archetypes',         result.last.tags.first
      end

      it "does not return duplicates" do
        assert_equal 7, result.size
      end
    end

  end

end