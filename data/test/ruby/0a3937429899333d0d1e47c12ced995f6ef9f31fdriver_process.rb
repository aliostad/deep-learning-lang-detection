require "chromedriver_proxy_pool/chromedriver_process_wrapper"
module ChromedriverProxyPool
  class DriverProcess
    def initialize
      @have_driver = false
      until have_driver?
        kill_old_driver_process
        start_new_driver_process
        ensure_driver_connection
      end
    end

    def port
      driver_process.port
    end

    private

    def have_driver?
      @have_driver
    end

    def kill_old_driver_process
      driver_process.kill
    end

    def driver_process
      @driver_process || NullDriverProcess.new
    end

    def start_new_driver_process
      @driver_process = ChromedriverProcessWrapper.new
    end

    def ensure_driver_connection
      @have_driver = driver_process.has_status?
    end

    class NullDriverProcess
      def kill
      end
    end
  end
end
