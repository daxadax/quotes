require 'minitest/autorun'

$LOAD_PATH.unshift('lib', 'spec')

# require all support files
Dir.glob('./spec/support/*.rb')  { |f| require f }

require 'quotes'

ENV['test'] = '1'


class FakeGatewayBackend

  def initialize
    @memories = Hash.new
    @next_id = 0
  end

  def reset
    @memories.clear
    @next_id = 0
  end

  def insert(quote)
    quote[:id] = next_id

    @memories[quote[:id]] = quote
    quote[:id]
  end

  def get(id)
    @memories[id]
  end

  def all
    @memories.values
  end

  def update(quote)
    @memories[quote[:id]] = quote
    quote[:id]
  end

  def delete(id)
    @memories.delete(id)
  end

  def toggle_star(id)
    quote = get(id)
    quote[:starred] == true ? quote[:starred] = false : quote[:starred] = true

    update quote
  end

  private

  def next_id
    @next_id += 1
  end

end

class Minitest::Spec
  include Support::AssertionHelpers
  include Support::FactoryHelpers
  include Quotes

  @@gateway_backend_stub = FakeGatewayBackend.new

  Quotes::Gateways::Gateway.send(:define_method, :backend_for_quotes) do
    @@gateway_backend_stub
  end

  after { @@gateway_backend_stub.reset }

end