require 'kindleclippings'

module Services
  class KindleImporter < Service

    def initialize
      @parser = KindleClippings::Parser.new
    end

    def import(clippings_file)
      validate(clippings_file)

      convert_to_excerpts(clippings_file)
    end

    private

    def validate(clippings_file)
      value   = clippings_file
      reason  = "Clippings file missing"

      raise_argument_error(reason, "run") if value.nil? || value.empty?
    end

    def convert_to_excerpts(clippings_file)
      clippings = parse clippings_file

      clippings.map do |clipping|
        build_excerpt_from clipping
      end.compact
    end

    def build_excerpt_from(clipping)
      author  = clipping.author
      title   = clipping.book_title
      content = clipping.content
      page    = clipping.page

      unless clipping.type == :Bookmark
        Entities::Excerpt.new(author, title, content, {:page_number => page})
      end
    end

    def parse(file_content)
      @parser.parse file_content
    end

  end
end