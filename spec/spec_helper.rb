require 'minitest/autorun'

$LOAD_PATH.unshift('lib', 'spec')
Dir.glob('./spec/**/*_spec.rb') { |f| require f }

require 'quotes'

class QuotesSpec < Minitest::Spec
  include Quotes

end
