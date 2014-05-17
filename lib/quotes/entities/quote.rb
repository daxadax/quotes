module Entities
  class Quote < Entity
    attr_reader   :author, :title, :content, :source, :tags
    attr_accessor :id

    def initialize(author, title, content, options = {})
      validate(author, title, content)

      @author   = author
      @title    = title
      @content  = content
      @source   = build_source(options)
      @tags     = options[:tags]  || []
      @id       = options[:id]    || nil
    end

    private

    def validate(author, title, content)
      ['author', 'title', 'content'].each do |param_name|
        value   = eval(param_name)
        reason  = "#{param_name.capitalize} missing"

        raise_argument_error(reason, value) if value.nil? || value.empty?
      end
    end

    def build_source(options)
      {
        :publisher    => options[:publisher]    || nil,
        :year         => options[:year]         || nil,
        :page_number  => options[:page_number]  || nil
      }
    end

  end
end
