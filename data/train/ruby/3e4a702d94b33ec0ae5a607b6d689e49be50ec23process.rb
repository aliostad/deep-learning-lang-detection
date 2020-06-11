module Fastest
  module Linux 
    # Process class for the Linux platform (see {GenericProcess})
    class Process < Fastest::Unix::Process

      protected

      # Returns the state of the process
      # @return [Hash] hash of symbols which represent the state
      def state
        process = Sys::ProcTable.ps(@pid)
        state_conds = { :running => true }
        unless process.nil?
          case process.state
          when 'D'
            # uninterruptible sleep (usually IO)
            state_conds[:sleeping] = true
          when 'R'
            # running or runnable (on run queue)
          when 'S'
            # interruptible sleep (waiting for an event to complete)
            state_conds[:sleeping] = true
          when 'T'
            # stopped, either by a job control signal or because it is being traced
            # this also happens when you do a CTRL-Z on a foreground process
            state_conds[:stopped] = true
          when 'W'
            # paging (not valid since the 2.6.xx kernel)
          when 'X'
            # dead (should never be seen)
            state_conds[:running] = false
          when 'Z'
            # defunct ("zombie") process, terminated but not reaped by its parent
            state_conds[:stopped] = true
          else
            raise Exception::UnknownProcessState, "Unknown process state: #{process.state}"
          end
        else
          # process not found
          state_conds[:running] = false
        end
        state_conds
      end

      private

      # Convert a Struct::ProcTableStruct entry into a Fastest::Process
      # @param [Struct::ProcTableStruct] process structure returned by Sys::ProcTable.ps
      # @return [Process] corresponding Fastest::Process
      def self.sys_process_to_process (process)
        # starttime as reported by /proc is the number of jiffies since last boot
        created_at = Fastest::Platform.system_boot_time
        created_at += process.starttime / Fastest::Platform.system_clock_tick.to_f
        Process.new(process.pid, created_at, process.ppid, process.name, process.exe, process.cmdline)
      end
    end
  end
end
