require_relative 'process_monitor'

module Salemove
  module ProcessHandler

    def self.start_composite(&block)
      CompositeProcess.new(&block).start
    end

    class CompositeProcess
      
      def initialize(&block)
        @process_spawners = []
        @monitor = CompositeProcessMonitor.new
        instance_eval &block if block_given?
      end

      def add(process, service)
        @monitor.add process.process_monitor
        @process_spawners << Proc.new { process.spawn service, blocking: false }
      end

      def start
        @process_spawners.each(&:call)
        @monitor.start
        block
      end

      def block
        sleep 1 while @monitor.running?
      end

    end

    class CompositeProcessMonitor < ProcessMonitor

      def initialize
        @monitors = []
      end

      def add(monitor)
        @monitors << monitor
      end

      def stop
        @monitors.each(&:stop)
        sleep 1 while @monitors.any?(&:alive?)
        super
      end

    end

  end
end