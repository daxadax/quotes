class Excerpt
  attr_reader :author, :title, :content, :source

  def initialize(author, title, content, options = {})
    @author   = author
    @title    = title
    @content  = content
    @source   = build_source(options)
  end

  def build_source(options)
    {
      :publisher    => options[:publisher]    || nil,
      :year         => options[:year]         || nil,
      :page_number  => options[:page_number]  || nil
    }
  end
  
end

