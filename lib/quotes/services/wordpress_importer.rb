require 'nokogiri'

module Services
  class WordpressImporter < Service

    TAG_BLACKLIST = %w[ quotes anecdotes concepts Uncategorized ]

    def initialize
      @parser = Nokogiri
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
      items = retrieve_items_from input

      items.map do |item|
        build_excerpt_from item.element_children
      end.compact
    end

    def build_excerpt_from(item)
      title   = fetch_title item
      page    = fetch_page_number item
      author  = fetch_author item
      content = fetch_content item
      tags    = build_tags item, author

      options = build_options(page, tags)

      Entities::Quote.new(author, title, content, options)
    end

    def build_options(page, tags)
      {
        :page_number  => page,
        :tags         => tags
      }
    end

    def fetch_title(item)
      # if there are page numbers, don't show them
      if content_at(item, 1).match(/,\spg\s\d*/)
        content_at(item, 1).gsub(/,\spg\s\S*/, '')
      else
        content_at(item, 1)
      end
    end

    def fetch_page_number(item)
      if content_at(item, 1).match(/pg\s.*/)
        page = content_at(item, 1).match(/pg\s.*/)[0]
        page.delete "pg "
      else
        return nil
      end
    end

    def fetch_author(item)
      content_at(item, 0)
    end

    def fetch_content(item)
      content = content_at(item, 7)

      content
    end

    def build_tags(item, author)
      tags = fetch_tags item

      tags.reject do |tag|
        author.match(tag) || TAG_BLACKLIST.include?(tag) || tag.strip.empty?
      end
    end

    def fetch_tags(item)
      item[21...-1].map do |tag|
        tag.children.first.content
      end
    end

    def content_at(item, position)
      item[position].children.first.content
    end

    def retrieve_items_from(input)
      parsed_input = @parser.XML(input)

      parsed_input.css('item')
    end

  end
end
