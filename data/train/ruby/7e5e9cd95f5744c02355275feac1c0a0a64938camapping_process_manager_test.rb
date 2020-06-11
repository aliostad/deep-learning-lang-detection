require 'test_helper'
require 'process_manager/mapping/fixtures'

module Synapse
  module Configuration
    class MappingProcessManagerDefinitionBuilderTest < Test::Unit::TestCase

      def setup
        @container = Container.new
        @builder = ContainerBuilder.new @container
      end

      should 'build with sensible defaults' do
        @builder.factory :process_repository do
          ProcessManager::InMemoryProcessRepository.new
        end

        @builder.process_factory
        @builder.process_manager do
          use_process_types ProcessManager::OrderProcess
        end

        process_manager = @container.resolve :process_manager

        assert_equal [process_manager], @container.resolve_tagged(:event_listener)

        factory = @container.resolve :process_factory
        repository = @container.resolve :process_repository

        assert_same factory, process_manager.factory
        assert_same repository, process_manager.repository
        assert_instance_of ProcessManager::PessimisticLockManager, process_manager.lock_manager
      end

    end
  end
end
