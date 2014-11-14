require 'json'

module Support
  module FactoryHelpers

    def create_quote(options = {})
      options.merge(:publication_uid => create_publication)

      quote = build_quote(options)

      uid = quotes_gateway.add quote
      quotes_gateway.get uid
    end

    def build_quote(options = {})
      added_by = options[:added_by] || 23
      content = options[:content] || 'Content'
      publication_uid= options[:publication_uid] || 99

      Quotes::Entities::Quote.new(added_by, content, publication_uid, options)
    end

    def create_publication(options = {})
      publication = build_publication(nil, options)

      publications_gateway.add publication
    end

    def build_publication(uid, options = {})
      author = options[:author] || 'Author'
      title = options[:title] || 'Title'
      publisher = options[:publisher] || 'Publisher'
      year = options[:year] || 1963
      uid = uid

      Quotes::Entities::Publication.new(author, title, publisher, year, uid)
    end

    def build_serialized_quote(options = {})
      added_by = options[:added_by] || 23
      content = options[:content] || 'Content'
      publication_uid = options[:publication_uid] || 99

      {
        :uid => options[:uid] || nil,
        :added_by => added_by,
        :content => content,
        :publication_uid => publication_uid,
        :page_number => options[:page_number] || nil,
        :tags => build_tags(options),
        :links => build_links(options)
      }
    end

    def build_serialized_publication(options = {})
      {
        :uid => options[:uid] || nil,
        :author => 'author',
        :title => options[:title] || 'title',
        :publisher => 'publisher',
        :year => 1999
      }
    end

    private

    def build_tags(options)
      tags = options[:tags] || []

      return dump(tags) unless options[:no_json]
      tags
    end

    def build_links(options)
      links = options[:links] || []

      return dump(links) unless options[:no_json]
      links
    end

    def dump(obj)
      JSON.dump(obj)
    end

  end
end
