require_relative "linepipe/version"
require_relative "linepipe/process"

module Linepipe
  class << self

    def develop(&block)
      build_process(block) { |process| process.develop }
    end

    def run(&block)
      build_process(block) { |process| process.run }
    end

    def benchmark(iterations, &block)
      build_process(block) { |process| process.benchmark(iterations) }
    end


    private

    def build_process(dsl_block, &block)
      Process.new.tap do |process|
        process.instance_eval(&dsl_block)
        yield process
      end
    end
  end
end
