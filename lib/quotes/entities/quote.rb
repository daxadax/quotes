module Entities
  class Quote < Entity
    attr_reader   :author, :title, :content
    attr_accessor :id, :publisher, :year, :page_number, :tags

    def initialize(author, title, content, options = {})
      validate(author, title, content)

      @author       = author
      @title        = title
      @content      = content
      @publisher    = options[:publisher]   || nil
      @year         = options[:year]        || nil
      @page_number  = options[:page_number] || nil
      @tags         = options[:tags]        || []
      @id           = options[:id]          || nil
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
