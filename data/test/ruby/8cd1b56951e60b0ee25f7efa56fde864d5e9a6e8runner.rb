require 'runnerbean/process_group'

module Runnerbean
  class Runner
    attr_reader :name

    def initialize(opts = {})
      @name = opts[:name] || 'runner'
    end

    def add_process(opts)
      opts.each do |key, value|
        process_index[key] = value
      end
    end

    def kill!(*process_names)
      pg = process_group(*process_names)
      pg.name = name
      pg.kill!
      pg # allows chaining
    end

    def start!(*process_names)
      pg = process_group(*process_names)
      pg.name = name
      pg.start!
      pg # allows chaining
    end

    def group(*process_names)
      process_group(*process_names)
    end

    private

    def process_group(*process_names)
      processes = processes_from_names(*process_names)
      ProcessGroup.new(*processes)
    end

    def processes_from_names(*process_names)
      process_names.map { |pn| process_from_name(pn) }
    end

    def process_from_name(name)
      process_index.fetch(name)
    rescue KeyError => e
      raise ProcessNotDefined, e.message
    end

    def process_index
      @process_index ||= {}
    end
  end
end
