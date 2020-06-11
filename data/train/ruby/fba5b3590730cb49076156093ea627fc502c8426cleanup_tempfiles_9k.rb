module Lookout
  module Jruby

    class << self
      
      # stolen from process_exists gem https://github.com/wilsonsilva/process_exists/blob/master/lib/process_exists/core_ext/process.rb
      def process_exists?(pid)
        Process.kill(0, pid.to_i)
        true
      rescue Errno::ESRCH # No such process
        false
      rescue Errno::EPERM # The process exists, but you dont have permission to send the signal to it.
        true
      rescue NotImplementedError
        # this can happen when native could not be loaded
        false
      end
      private :process_exists?

    end
  end
end
