module Quotes
  module Entities
    class Quote < Entity
      attr_accessor :uid, :content, :page_number, :tags
      attr_reader   :links, :added_by

      def initialize(added_by, content, publication_uid, options = {})
        validate!(added_by, content, publication_uid)

        @uid = options[:uid] || nil
        @added_by = added_by
        @content = content
        @publication_uid = publication_uid
        @page_number = options[:page_number] || nil
        @tags = options[:tags] || []
        @links = options[:links] || []
      end

      def publication_uid
        @publication_uid
      end

      def update_links(link)
        if @links.include?(link)
          @links.delete(link)
        else
          @links.push(link)
        end
      end

      private

      def validate!(added_by, content, publication_uid)
        ['added_by', 'content', 'publication_uid'].each do |param_name|
          value   = eval(param_name)
          reason  = "#{param_name.capitalize} missing"

          raise_argument_error(reason, value) if value.nil? || value.to_s.empty?
        end
      end

    end
  end

end
