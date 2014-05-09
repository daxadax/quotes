require 'spec_helper'

class PopulateGatewaySpec < UseCaseSpec

  let(:gateway)           { FakeGateway.new }
  let(:kindle_clippings)  { "spec/support/sample_kindle_clippings.txt"  }
  let(:wordpress_blog)    { "spec/support/sample_wordpress_blog.xml"    }
  let(:input) do
    {
      :gateway    => gateway,
      :kindle     => kindle_clippings,
      :wordpress  => wordpress_blog
    }
  end

  let(:use_case)          { UseCases::PopulateGateway.new(input) }

  describe "call" do

    before do
      use_case.call
    end

    it 'adds quotes to the given gateway' do
      assert_equal 6, gateway.size
    end

  end


  class FakeGateway

  end

end
