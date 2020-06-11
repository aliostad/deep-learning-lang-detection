require 'test_helper'

module Synapse
  module ProcessManager

    class InMemoryProcessRepositoryTest < Test::Unit::TestCase
      should 'support finding processes by correlations' do
        correlation_a = Correlation.new :order_id, 1
        correlation_b = Correlation.new :order_id, 2

        process_a = Process.new
        process_a.correlations.add correlation_a
        process_b = Process.new
        process_b.correlations.add correlation_b

        repository = InMemoryProcessRepository.new
        repository.add process_a
        repository.add process_b

        assert_equal [process_a.id], repository.find(Process, correlation_a)
        assert_equal [process_b.id], repository.find(Process, correlation_b)
      end

      should 'support loading processes by identifier' do
        repository = InMemoryProcessRepository.new

        process_a = Process.new
        process_b = Process.new

        repository.add process_a
        repository.add process_b

        assert_equal process_a, repository.load(process_a.id)
        assert_equal process_b, repository.load(process_b.id)
      end

      should 'mark processes as committed' do
        repository = InMemoryProcessRepository.new

        process = Process.new
        repository.commit process

        assert_equal 1, repository.count
        # Make sure the correlation set was marked as committed
        assert_equal 0, process.correlations.additions.count
        assert_equal 0, process.correlations.deletions.count

        process.send :finish

        repository.commit process

        assert_equal 0, repository.count
      end
    end

  end
end
