require 'spec_helper'

class AutotagSpec < ServiceSpec
  let(:autotag) { Services::Autotag.new(quote) }
  let(:result) { autotag.run }

  describe 'with content which does not include any current tags' do
    let(:quote) { create_quote }

    it 'does not add tags' do
      assert_empty result.tags
    end
  end

  describe 'with content which includes current tags' do
    let(:quote) { create_quote :content => 'all is fair in love and warts' }
    before { add_sample_quotes_to_db }

    it 'adds whole-string matching tags' do
      assert_equal 1, result.tags.size
      assert_includes result.tags, 'love'
      refute_includes result.tags, 'war'
    end
  end


  private

  USED_TAGS = [
    'love',
    'death',
    'hope',
    'war',
    'earthworms'
  ]

  def add_tag_to_quote(quote, tag)
    quotes_gateway.update(
      quote.tap { |q| q.tags << tag }
    )
  end

  def add_sample_quotes_to_db
    5.times do |index|
      options_for_quote = {
        :content => "A quote about #{USED_TAGS[index]}",
        :tags => [USED_TAGS[index]]
      }

      create_quote options_for_quote
    end
  end
end
