require 'kindleclippings'

module Services
  class KindleImporter < Service

    def initialize
      @parser = KindleClippings::Parser.new
    end

    def import(input)
      validate(input)

      convert_to_excerpts(input)
    end

    private

    def validate(input)
      reason  = "Input missing"

      raise_argument_error(reason, input) if input.nil? || input.empty?
    end

    def convert_to_excerpts(input)
      clippings = parse input

      clippings.map do |clipping|
        build_excerpt_from clipping unless clipping.type == :Bookmark
      end.compact
    end

    def build_excerpt_from(clipping)
      author  = clipping.author
      title   = clipping.book_title
      content = clipping.content
      page    = clipping.page

      unless content.empty?
        Entities::Excerpt.new(author, title, content, {:page_number => page})
      end
    end

    def parse(file_content)
      @parser.parse file_content
    end

  end
end