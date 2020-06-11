require 'test_helper'

module Synapse
  module ProcessManager
    module Mongo
      class MongoProcessRepositoryTest < Test::Unit::TestCase

        def setup
          client = ::Mongo::MongoClient.new
          template = Template.new client
          template.process_collection.drop

          converter_factory = Serialization::ConverterFactory.new
          serializer = Serialization::MarshalSerializer.new converter_factory

          @repository = MongoProcessRepository.new serializer, template
        end

        should 'persist processes to the database' do
          process = Process.new

          @repository.add process
          loaded = @repository.load process.id

          assert_equal process.id, loaded.id
          assert_equal 0, process.correlations.additions.count
        end

        should 'commit changes to processes to the database' do
          correlation = Correlation.new :order_id, '123'

          process = Process.new
          @repository.add process

          process.correlations.add correlation
          @repository.commit process

          loaded = @repository.load process.id

          assert loaded.correlations.include? correlation

          loaded.send :finish
          @repository.commit loaded

          assert_nil @repository.load process.id
        end

        should 'support finding processes by their correlation keys' do
          correlation_a = Correlation.new :order_id, '123'
          correlation_b = Correlation.new :order_id, '456'

          process_a = Process.new
          process_a.correlations.add correlation_a
          @repository.add process_a
          process_b = Process.new
          process_b.correlations.add correlation_a
          @repository.add process_b
          process_c = Process.new
          process_c.correlations.add correlation_b
          @repository.add process_c

          identifiers = @repository.find Process, correlation_a
          assert_equal Set[process_a.id, process_b.id], identifiers
          identifiers = @repository.find Process, correlation_b
          assert_equal Set[process_c.id], identifiers
        end

      end
    end
  end
end
