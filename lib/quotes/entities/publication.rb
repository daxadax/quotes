module Quotes
  module Entities
    class Publication < Entity
      attr_accessor :author, :title, :publisher, :year
      attr_reader :uid

      def initialize(author, title, publisher, year, uid = nil)
        validate(author, title, publisher, year)

        @uid = uid
        @author = author
        @title = title
        @publisher = publisher
        @year = year
      end

      private

      def validate(author, title, publisher, year)
        ['author', 'title', 'publisher', 'year'].each do |param_name|
          value   = eval(param_name)
          reason  = "#{param_name.capitalize} missing"

          raise_argument_error(reason, value) if value.nil? || value.to_s.empty?
        end
      end

    end
  end
end
