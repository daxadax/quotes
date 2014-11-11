require 'spec_helper'

class QuoteSpec < Minitest::Spec
  let(:added_by) { 23 }
  let(:content) { 'four score and...' }
  let(:publication_uid) { 99 }
  let(:options) { {} }

  let(:quote) do
    Entities::Quote.new(added_by, content, publication_uid, options)
  end

  describe 'construction' do
    it 'can be built with two arguments and the publication_uid it belongs to' do
      assert_equal 23, quote.added_by
      assert_equal 'four score and...', quote.content
      assert_equal publication_uid, quote.publication_uid
    end

    it "has sane defaults for non-required arguments" do
      assert_nil quote.uid
      assert_nil quote.page_number
      assert_empty quote.tags
      assert_empty quote.links
    end

    describe 'without' do

      describe 'publication_uid' do
        let(:publication_uid) { nil }

        it('fails') {assert_failure{quote}}
      end

      describe 'added_by' do
        let(:added_by)  {nil}
        it('fails')   {assert_failure{quote}}
      end

      describe 'content' do
        let(:content) {nil}
        it('fails')   {assert_failure{quote}}
      end

    end

    describe 'can build all other attributes' do
      let(:tags) { ['tag_one', 'tag_two', 'tag_three'] }
      let(:options) do
        {
          :tags => tags,
          :page_number  => '356'
        }
      end

      it 'with an options hash' do
        assert_equal 3, quote.tags.size
        assert_equal '356',         quote.page_number
      end

      it "can be updated" do
        new_tags = %w[some new tags]
        quote.tags = quote.tags + new_tags

        assert_equal 6, quote.tags.count
      end
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
      quote.content = "updated content"

      assert_equal 'updated content', quote.content
    end
  end

end
