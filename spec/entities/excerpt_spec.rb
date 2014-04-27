require 'spec_helper'

class ExcerptSpec < QuotesSpec
  let(:author)  { 'joe' }
  let(:title)   { 'joes book' }
  let(:content) { 'four score and...' }
  let(:options) { {} }

  let(:excerpt) do
    Entities::Excerpt.new(
      author,
      title,
      content,
      options
    )
  end

  describe 'construction' do
    it 'can be built with three arguments' do
      assert_equal 'joe',               excerpt.author
      assert_equal 'joes book',         excerpt.title
      assert_equal 'four score and...', excerpt.content
      excerpt.source.each do |key, value|
        assert_nil value
      end
    end

    describe 'without' do

      describe 'author' do
        let(:author)  {nil}
        it('fails')   {assert_failure}
      end

      describe 'title' do
        let(:title) {nil}
        it('fails') {assert_failure}
      end

      describe 'content' do
        let(:content) {nil}
        it('fails')   {assert_failure}
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
        assert_equal 'free press',  excerpt.source[:publisher]
        assert_equal '1969',        excerpt.source[:year]
        assert_equal '356',         excerpt.source[:page_number]
      end
    end

  end

  def assert_failure
    assert_raises(ArgumentError) { excerpt }
  end

end