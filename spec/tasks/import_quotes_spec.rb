require 'spec_helper'
require 'support/fake_gateway_access'

class ImportQuotesSpec < FakeGatewayAccess

  let(:file) do
    File.read("spec/support/kindle_clippings_with_dups.txt")
  end
  let(:user_uid) { 23 }
  let(:task) { Tasks::ImportQuotes.new(user_uid, file) }

  describe "run" do

    describe 'with input that cannot be parsed' do
      let(:file) { "some nonsense" }

      it 'nothing is added to the gateway' do
        assert_raises(ArgumentError) { task.run }
        assert_empty quotes_gateway.all
      end
    end

    describe "with parsable input" do

      it "adds all quote entities to the gateway" do
        task.run

        result = quotes_gateway.all
        assert_kind_of Array, result
        assert_kind_of Entities::Quote, result.last
        assert_equal 23, result.last.added_by
        assert_equal 'Sample Author', result.last.author
        assert_includes result.last.content, 'sample highlight'
      end

      describe 'with duplicate quotes' do
        before do
          seed_database_with_duplicate_quotes
        end

        it "does not return duplicates" do
          task.run

          assert_equal 3, quotes_gateway.all.size
        end
      end

      def seed_database_with_duplicate_quotes
        file = File.read("spec/support/sample_kindle_clippings.txt")
        Tasks::ImportQuotes.new(user_uid, file).run
      end
    end

  end

end
