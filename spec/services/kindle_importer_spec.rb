require 'spec_helper'

class KindleImporterSpec < Minitest::Spec
  let(:kindle_importer) { Services::KindleImporter.new }
  let(:clippings) do
    File.read("spec/support/sample_kindle_clippings.txt")
  end

  let(:result)          { kindle_importer.import(clippings) }

  describe 'import' do

    describe 'without a valid clippings file' do
      let(:clippings)   { '' }

      it 'fails' do
        assert_failure {result}
      end
    end
    
    describe 'with a valid clippings file' do
      let(:first_result)  { result[0] } 

      it 'parses the file into exceprts' do
        assert_kind_of Entities::Excerpt, first_result
      end

      it 'returns an array of objects' do
        assert_kind_of Array, result
      end

      it 'only parses notes and highlights' do
        assert_equal 2, result.size
      end
    end

  end

end