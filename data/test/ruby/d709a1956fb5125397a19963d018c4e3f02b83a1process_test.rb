require 'test_helper'

module Synapse
  module ProcessManager

    class ProcessTest < Test::Unit::TestCase
      should 'initialize with sensible defaults' do
        process = StubProcess.new
        correlation = Correlation.new :process_id, process.id

        # If no identifier was given, one should be generated
        refute process.id.nil?
        assert process.correlations.include? correlation
        assert process.active?
      end

      should 'support deletion of a correlation' do
        process = StubProcess.new

        key = :order_id
        value = '512d5467'

        process.cause_correlate key, value
        assert process.correlations.include? Correlation.new(key, value)

        process.cause_dissociate key, value
        refute process.correlations.include? Correlation.new(key, value)
      end

      should 'be able to be marked as finished' do
        process = StubProcess.new
        process.cause_finish

        refute process.active?
      end
    end

    class StubProcess < Process
      def cause_finish
        finish
      end

      def cause_correlate(key, value)
        correlate_with key, value
      end
      def cause_dissociate(key, value)
        dissociate_from key, value
      end
    end

  end
end
