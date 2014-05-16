module Entities
  class Excerpt < Entity
    attr_reader :id, :author, :title, :content, :source, :tags

    def initialize(author, title, content, options = {})
      validate(author, title, content)

      @id       = nil
      @author   = author
      @title    = title
      @content  = content
      @source   = build_source(options)
      @tags     = options[:tags] || nil
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
