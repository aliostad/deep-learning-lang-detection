module Synapse
  module Configuration
    # Definition builder used to create a mapping process manager
    #
    # Since process managers are effectively listeners on the event bus, definitions created by
    # this builder will be tagged with `:event_listener`
    #
    # @example The minimum possible effort to build a process manager
    #   process_manager do
    #     use_process_types MoneyTransferProcess
    #   end
    #
    # @example Build a process manager with alternate components
    #   process_manager :alt_process_manager do
    #     use_process_types MoneyTransferProcess
    #
    #     use_process_repository :alt_process_repository
    #     use_process_factory :alt_process_factory
    #
    #     # Use a different tag for subscribing to an event bus
    #     replace_tags :alt_event_listener
    #   end
    class MappingProcessManagerDefinitionBuilder < DefinitionBuilder
      # Changes the lock manager to use with this process manager
      #
      # @see ProcessManager::LockManager
      # @param [Symbol] lock_manager
      # @return [undefined]
      def use_lock_manager(lock_manager)
        @lock_manager = lock_manager
      end

      # Changes the lock manager to a pessimistic lock manager
      #
      # @see ProcessManager::PessimisticLockManager
      # @return [undefined]
      def use_pessimistic_locking
        @lock_manager_type = ProcessManager::PessimisticLockManager
      end

      # Changes the process factory to use with this process manager
      #
      # @see ProcessManager::ProcessFactory
      # @param [Symbol] process_factory
      # @return [undefined]
      def use_process_factory(process_factory)
        @process_factory = process_factory
      end

      # Changes the process repository to use with this process manager
      #
      # @see ProcessManager::ProcessRepository
      # @param [Symbol] process_repository
      # @return [undefined]
      def use_process_repository(process_repository)
        @process_repository = process_repository
      end

      # Changes the process types that are hosted by this process manager
      #
      # @see ProcessManager::Process
      # @param [Class...] process_types
      # @return [undefined]
      def use_process_types(*process_types)
        @process_types = process_types.flatten
      end

    protected

      # @return [undefined]
      def populate_defaults
        identified_by :process_manager

        tag :event_listener

        use_pessimistic_locking
        use_process_factory :process_factory
        use_process_repository :process_repository

        use_factory do
          lock_manager = build_lock_manager
          factory = resolve @process_factory
          repository = resolve @process_repository

          ProcessManager::MappingProcessManager.new repository, factory, lock_manager, @process_types
        end
      end

      # @raise [RuntimeError] If no lock manager was configured
      # @return [LockManager]
      def build_lock_manager
        if @lock_manager
          resolve @lock_manager
        elsif @lock_manager_type
          @lock_manager_type.new
        else
          raise 'No lock manager was configured for this process manager'
        end
      end
    end # MappingProcessManagerDefinitionBuilder
  end # Configuration
end
