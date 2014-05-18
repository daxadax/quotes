require 'minitest/autorun'

$LOAD_PATH.unshift('lib', 'spec')

# require all support files
Dir.glob('./spec/support/*.rb')  { |f| require f }

require 'quotes'

ENV['test'] = '1'
ENV['DATABASE_URL'] = 'sqlite://quotes-test.db'

class Minitest::Spec
  include Support::AssertionHelpers
  include Support::FactoryHelpers
  include Quotes

end
