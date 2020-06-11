module DontStallMyProcess
  module Local
    class ChildProcessPool
      MAX_ALLOC_TRIES = 5
      SEMAPHORE = Mutex.new

      def self.alloc
        process = nil
        tries   = MAX_ALLOC_TRIES
        until (process && process.alive?) || tries == 0
          tries -= 1
          SEMAPHORE.synchronize do
            if !@pool || @pool.empty?
              process = ChildProcess.new
            else
              process = @pool.shift
            end
          end
        end

        unless process && process.alive?
          fail SubprocessInitializationFailed, "failed to allocated subprocess (tried #{MAX_ALLOC_TRIES} times)"
        end

        process
      end

      def self.free(process)
        # We do not want killed processes to enter the pool again.
        return unless process.alive?

        terminate = true

        if Configuration.process_pool_size && Configuration.process_pool_size > 0
          SEMAPHORE.synchronize do
            @pool ||= []
            if @pool.size < Configuration.process_pool_size
              @pool << process
              terminate = false
            end
          end
        end

        process.quit if terminate
      end

      def self.each(&block)
        @pool.each(&block) if @pool
      end
    end
  end
end
