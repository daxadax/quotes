require 'quotes/use_cases/use_case'
Dir.glob('./lib/quotes/use_cases/*.rb') { |f| require f }

module Quotes
  module UseCases
  end
end
