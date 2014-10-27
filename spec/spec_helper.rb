require 'minitest/autorun'

$LOAD_PATH.unshift('lib', 'spec')

# require all support files
Dir.glob('./spec/support/*.rb')  { |f| require f }

require 'quotes'

ENV['test'] = '1'


class FakeGatewayBackend

  def initialize
    @memories = Hash.new
    @next_uid = 0
  end

  def reset
    @memories.clear
    @next_uid = 0
  end

  def insert(quote)
    quote[:uid] = next_uid

    @memories[quote[:uid]] = quote
    quote[:uid]
  end

  def get(uid)
    @memories[uid]
  end

  def all
    @memories.values
  end

  def update(quote)
    @memories[quote[:uid]] = quote
    quote[:uid]
  end

  def delete(uid)
    @memories.delete(uid)
  end

  def toggle_star(uid)
    quote = get(uid)
    quote[:starred] == true ? quote[:starred] = false : quote[:starred] = true

    update quote
  end

  private

  def next_uid
    @next_uid += 1
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