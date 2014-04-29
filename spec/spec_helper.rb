require 'minitest/autorun'

$LOAD_PATH.unshift('lib', 'spec')

# require all support files
Dir.glob('./spec/support/*.rb')  { |f| require f }

# require all spec files
Dir.glob('./spec/**/*spec.rb')  { |f| require f }

require 'quotes'

class Minitest::Spec
  include Support::AssertionHelpers
  include Quotes

end
