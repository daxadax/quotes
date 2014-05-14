require 'spec_helper'

class GetQuotesSpec < TaskSpec

  let(:files) do
    [
      File.read("spec/support/sample_kindle_clippings.txt"),
      File.read("spec/support/kindle_clippings_with_dups.txt"),
      File.read("spec/support/sample_wordpress_blog.xml")
    ]
  end
  let(:fake_gateway)  { FakeGateway.new }
  let(:get_quotes)    { Tasks::GetQuotes.new(files, fake_gateway) }

  describe "run" do

    before do
      get_quotes.run
    end

    describe 'without a "files" argument' do
      let(:files) { nil }

      it 'reads input from the seeds directory or renders an error message' do
        skip
        assert_equal "error", result
      end
    end

    describe "with no files" do
      let(:files) { [] }

      it "returns an empty array" do
        assert_empty result
      end
    end

    describe "with input" do
      it "adds a collection of excerpt entities to the gateway" do
        assert_kind_of  Entities::Excerpt,  result.first
      end

      it "does not return duplicates" do
        assert_equal 7, result.size
      end
    end

  end

  def result
    @result ||= fake_gateway.all
  end

  class FakeGateway

    def initialize
      @memory = []
    end

    def add(quotes)
      quotes.each do |quote|
        @memory << quote
      end
    end

    def all
      @memory
    end

  end

end