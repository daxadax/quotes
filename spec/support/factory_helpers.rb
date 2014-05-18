require 'json'

module Support
  module FactoryHelpers

    def build_quote(options = {})
      author  = options[:author]  || 'Author'
      title   = options[:title]   || 'Title'
      content = options[:content] || 'Content'

      Entities::Quote.new(author, title, content, options)
    end

    def build_serialized_quote(options = {})
      author  = options[:author]  || 'Author'
      title   = options[:title]   || 'Title'
      content = options[:content] || 'Content'

      {
        :author       => author,
        :title        => title,
        :content      => content,
        :publisher    => options[:publisher]    || nil,
        :year         => options[:year]         || nil,
        :page_number  => options[:page_number]  || nil,
        :tags         => build_tags(options),
        :id           => options[:id]           || nil
      }
    end

    private

    def build_tags(options)
      tags = options[:tags] || []

      JSON.dump(tags)
    end

  end
end