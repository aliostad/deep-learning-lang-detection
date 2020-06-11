module Synapse
  module ProcessManager
    # Lock manager that blocks until a lock can be obtained for a process
    class PessimisticLockManager
      def initialize
        @manager = IdentifierLockManager.new
      end

      # @param [String] process_id
      # @return [undefined]
      def obtain_lock(process_id)
        @manager.obtain_lock process_id
      end

      # @raise [ThreadError] If thread didn't previously hold the lock
      # @param [String] process_id
      # @return [undefined]
      def release_lock(process_id)
        @manager.release_lock process_id
      end
    end # PessimisticLockManager
  end # ProcessManager
end
