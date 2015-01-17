module Quotes
  module UseCases
    class ImportFromKindle < UseCase

      def initialize(input)
        validate input

        @user_uid = input[:user_uid]
        @file = input[:file]
      end

      def call
        import_unique_quotes
      end

      private

      def import_unique_quotes
        quotes = parse file

        add_to_gateway quotes
      end

      def remove_duplicates(quotes)
        quotes.uniq { |quote| quote.content }
      end

      def add_to_gateway(quotes)
        quotes.each do |quote|
          next if duplicate?(quote)
          quotes_gateway.add(quote)
        end
      end

      def duplicate?(new_quote)
        duplicate = quotes_gateway.all.detect do |persisted_quote|
          persisted_quote.author == new_quote.author &&
          persisted_quote.title == new_quote.title &&
          string_diff(persisted_quote, new_quote) <= 0.1
        end

        return true if duplicate
        false
      end

      def string_diff(original, new_string)
        original = original.content.split(' ')
        new_string = new_string.content.split(' ')

        (original - new_string).size / original.size.to_f
      end

      def parse(file)
        Services::KindleImporter.new(user_uid, file).import
      end

      def validate(input)
        validate_user_uid input[:user_uid]
        validate_file input[:file]
      end

      def validate_user_uid(user_uid)
        msg = "Not a valid user uid"
        raise ArgumentError, msg unless user_uid.is_a? Integer
      end

      def validate_file(file)
        msg = "Not a valid kindle clippings file"
        raise ArgumentError, msg unless file.start_with?("==")
      end

      def user_uid
        @user_uid
      end

      def file
        @file
      end

    end
  end
end
