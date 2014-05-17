module Support
  module FactoryHelpers

    def build_quote(options = {} )
      author  = options[:author]  || 'Author'
      title   = options[:title]   || 'Title'
      content = options[:content] || 'Content'

      Entities::Quote.new(author, title, content, options)
    end

  end
end