module Quotes
  module UseCases
    class ToggleStar < UseCase

      def initialize(input)
        ensure_valid_input!(input[:uid])

        @uid = input[:uid]
      end

      def call
        gateway.toggle_star(@uid)
      end

    end
  end
end