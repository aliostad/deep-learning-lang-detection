require 'test_helper'

module Synapse
  module ProcessManager
    class GenericProcessFactoryTest < Test::Unit::TestCase
      should 'be able to create processes' do
        injector = Object.new

        mock(injector).inject_resources(is_a(Process))

        factory = GenericProcessFactory.new
        factory.resource_injector = injector

        process = factory.create Process

        assert process.is_a? Process
      end

      should 'be able to determine if a process implementation is supported' do
        factory = GenericProcessFactory.new

        assert factory.supports Process
        refute factory.supports StubProcessWithArguments
      end
    end

    class StubProcessWithArguments < Process
      def initialize(some_resource); end
    end
  end
end
