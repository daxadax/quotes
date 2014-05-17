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
        :author   => author,
        :title    => title,
        :content  => content,
        :source   => options[:source] || nil,
        :tags     => options[:tags]   || [],
        :id       => options[:id]     || nil
      }
    end

  end
end