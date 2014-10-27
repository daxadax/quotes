require 'json'

module Support
  module FactoryHelpers

    def create_quote(options = {})
      quote   = build_quote(options)
      gateway = Quotes::Gateways::QuotesGateway.new

      uid = gateway.add quote
      gateway.get uid
    end

    def build_quote(options = {})
      author  = options[:author]  || 'Author'
      title   = options[:title]   || 'Title'
      content = options[:content] || 'Content'

      Quotes::Entities::Quote.new(author, title, content, options)
    end

    def build_serialized_quote(options = {})
      author  = options[:author]  || 'Author'
      title   = options[:title]   || 'Title'
      content = options[:content] || 'Content'

      {
        :author       => author,
        :title        => title,
        :content      => content,
        :uid          => options[:uid]          || nil,
        :publisher    => options[:publisher]    || nil,
        :year         => options[:year]         || nil,
        :page_number  => options[:page_number]  || nil,
        :starred      => options[:starred]      || false,
        :tags         => build_tags(options),
        :links        => build_links(options)
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