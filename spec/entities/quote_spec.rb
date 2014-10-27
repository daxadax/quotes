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
    end

    it "has sane defaults for non-required arguments" do
      assert_nil    quote.uid
      assert_nil    quote.publisher
      assert_nil    quote.year
      assert_nil    quote.page_number
      assert_empty  quote.tags
      assert_empty  quote.links
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

    describe 'can build a other attributes' do
      let(:options) do
        {
          :publisher    => 'free press',
          :year         => '1969',
          :page_number  => '356',
        }
      end

      it 'with an options hash' do
        assert_equal 'free press',  quote.publisher
        assert_equal '1969',        quote.year
        assert_equal '356',         quote.page_number
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

      it "can be updated" do
        new_tags = %w[some new tags]
        quote.tags = quote.tags + new_tags

        assert_equal 6, quote.tags.count
      end
    end

    describe "links" do
      let(:links) { [23, 666, 17] }
      let(:options) do
        {
          :links => links
        }
      end

      it "can be built with an options hash" do
        assert_equal 3, quote.links.size
      end

      describe "updating" do
        let(:new_link)      { 113 }
        let(:existing_link) { links.first }

        it "can add links" do
          quote.update_links(new_link)

          assert_equal 4, quote.links.size
          assert_includes quote.links, new_link
        end

        it "can remove links" do
          quote.update_links(existing_link)

          assert_equal 2, quote.links.size
          refute_includes quote.links, existing_link
        end

      end
    end

    describe "updating attributes" do
      it "is possible" do
        quote.publisher = "a more correct publisher"

        assert_equal 'a more correct publisher', quote.publisher
      end
    end

  end

end
