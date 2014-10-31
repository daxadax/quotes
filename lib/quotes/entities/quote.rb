module Quotes
  module Entities
    class Quote < Entity
      attr_accessor :author, :title, :content, :uid, :publisher, :year, :page_number, :tags
      attr_reader   :links

      def initialize(author, title, content, options = {})
        validate(author, title, content)

        @author       = author
        @title        = title
        @content      = content
        @uid           = options[:uid]        || nil
        @publisher    = options[:publisher]   || nil
        @year         = options[:year]        || nil
        @page_number  = options[:page_number] || nil
        @tags         = options[:tags]        || []
        @links        = options[:links]       || []
      end

      def update_links(link)
        if @links.include?(link)
          @links.delete(link)
        else
          @links.push(link)
        end
      end

      private

      def validate(author, title, content)
        ['author', 'title', 'content'].each do |param_name|
          value   = eval(param_name)
          reason  = "#{param_name.capitalize} missing"

          raise_argument_error(reason, value) if value.nil? || value.empty?
        end
      end

    end
  end

end
