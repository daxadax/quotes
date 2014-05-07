require 'spec_helper'

class WordpressImporterSpec < Minitest::Spec
  let(:wordpress_importer)  { Services::WordpressImporter.new }
  let(:input) do
    File.read("spec/support/sample_wordpress_blog.xml")
  end

  let(:result)  { wordpress_importer.import(input) }

  describe 'import' do

    describe 'without valid input' do
      let(:input) { '' }

      it 'fails' do
        assert_failure  {result}
      end
    end
    
    describe 'with valid input' do
      let(:result_one)  { result[0] } 
      let(:result_two)  { result[1] }
      let(:last_result) { result[-1] }

      it 'parses the file into exceprts' do
        assert_kind_of Entities::Excerpt, result_one
      end

      it 'returns an array of all the objects' do
        assert_kind_of Array, result
        assert_equal 4,       result.size
      end

      it "formats content" do
        skip
      end

      it "creates the correct attributes for the Excerpts" do
        assert_equal "Hot, Flat, and Crowded",  result_one.title
        assert_equal "The Portable Nietzsche",  result_two.title
        assert_equal "The Origins and History of Consciousness", 
          last_result.title

        assert_equal "Thomas L. Friedman",      result_one.author
        assert_equal "Friedrich Nietzsche",     result_two.author
        assert_equal "Erich Neumann",           last_result.author

        assert_includes result_one.content,     "life on earth"
        assert_includes result_two.content,     "not to react"
        assert_includes last_result.content,    "psycho-evolutionary"

        assert_equal 6,                         result_one.tags.size
        assert_equal 6,                         result_two.tags.size
        assert_equal 4,                         last_result.tags.size

        assert_equal "555",                     result_one.source[:page_number]
        assert_equal "511",                     result_two.source[:page_number]
        assert_equal "xvii",                    last_result.source[:page_number]
      end

    end

  end

end
