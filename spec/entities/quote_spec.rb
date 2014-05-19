require 'spec_helper'

class QuoteSpec < Minitest::Spec
  let(:author)  { 'joe' }
  let(:title)   { 'joes book' }
  let(:content) { 'four score and...' }
  let(:options) { {} }

  let(:quote) do
    Entities::Quote.new(author, title, content, options)
  end

  describe 'construction' do
    it 'can be built with three arguments' do
      assert_equal 'joe',               quote.author
      assert_equal 'joes book',         quote.title
      assert_equal 'four score and...', quote.content
      quote.source.each do |key, value|
        assert_nil value
      end
    end

    it "has sane defaults for non-required arguments" do
      assert_nil    quote.id
      assert_nil    quote.source[:publisher]
      assert_nil    quote.source[:year]
      assert_nil    quote.source[:page_number]
      assert_empty  quote.tags
    end

    describe 'without' do

      describe 'author' do
        let(:author)  {nil}
        it('fails')   {assert_failure{quote}}
      end

      describe 'title' do
        let(:title) {nil}
        it('fails') {assert_failure{quote}}
      end

      describe 'content' do
        let(:content) {nil}
        it('fails')   {assert_failure{quote}}
      end

    end

    describe 'can build a source' do
      let(:options) do
        {
          :publisher    => 'free press',
          :year         => '1969',
          :page_number  => '356'
        }
      end

      it 'with an options hash' do
        assert_equal 'free press',  quote.source[:publisher]
        assert_equal '1969',        quote.source[:year]
        assert_equal '356',         quote.source[:page_number]
      end
    end

    describe 'tags' do
      let(:tags) { ['tag_one', 'tag_two', 'tag_three'] }
      let(:options) do
        {
          :tags => tags
        }
      end

      it "can be built with an options hash" do
        assert_equal 3, quote.tags.size
      end
    end

  end

end
