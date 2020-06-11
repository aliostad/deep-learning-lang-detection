require "rprifrc/resource_change_block_runner"
require "rprifrc/process_manager"

module Rprifrc
  class Runner
    def initialize(resource_change_block_runner, process_manager)
      @resource_change_block_runner = resource_change_block_runner
      @process_manager = process_manager
    end

    def run
      while !interrupted do
        run_process
      end
    end

    private

    attr_reader :resource_change_block_runner, :interrupted, :process_manager

    def run_process
      process_manager.ensure_started

      t = Thread.new {
        resource_change_block_runner.run(5) do
          process_manager.ensure_killed
        end
      }

      @interrupted = !process_manager.await

      t.kill
    end
  end
end
