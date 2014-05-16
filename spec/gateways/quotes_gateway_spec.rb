require 'spec_helper'

class QuotesGatewaySpec < GatewaySpec

  let(:output_file)   { fake_db_file }
  let(:gateway)       { Gateways::QuotesGateway.new(output_file) }
  let(:excerpts)      { build_fake_excerpts }
  let(:dup_excerpts)  { build_fake_excerpts_with_duplicates }
  let(:result)        { gateway.all }

  describe "add" do
    describe "failure" do
      it "validates each excerpt before adding" do
        excerpts = [23, 24, 25]

        assert_failure { gateway.add(excerpts) }
      end
    end

    describe "success" do
      before { gateway.add excerpts }

      it "serializes the given data and saves it to a file" do
        assert_equal 10,                    result.size
        assert_equal "Author 1",            result.first.author
        assert_equal "Book 1",              result.first.title
        assert_equal "Content for Book 1",  result.first.content
      end

      it "doesn't create duplications" do
        gateway.add dup_excerpts

        assert_equal 11,  result.size
      end

      it "adds a unique id to each quote before adding it to the gateway" do
        gateway.add dup_excerpts
        ids = result.map(&:id)

        assert_equal 11, ids.uniq.size
      end
    end
  end

  describe "all" do
    describe "with nothing in the gateway" do
      it "returns an empty array" do
        assert_empty gateway.all
      end
    end
  end

  describe "update" do

  end

  def build_fake_excerpts
    10.times.map do |i|
      author  = "Author #{(i%3)+1}"
      title   = "Book #{i+1}"
      content = "Content for #{title}"

      Entities::Excerpt.new(author, title, content)
    end
  end

  def build_fake_excerpts_with_duplicates
    dup_author  = "Author 2"
    dup_title   = "Book 1"
    dup_content = "Content for Book 1"

    [
      Entities::Excerpt.new(dup_author, dup_title, dup_content),
      Entities::Excerpt.new("New Author", "New Title", "New Content")
    ]
  end

end
