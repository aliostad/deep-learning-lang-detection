module EventSourcing
  class CommandProcessor < Processor
    def initialize
      super
      @handlers = {}
    end

    def add_handler(event_type, handler)
      @handlers[event_type] = handler
    end

    def process event
      handler = handler_for(event.type)
      log("No handler found for #{event.type}") unless handler
      handler.process(event)
    end

    private

    def handler_for(event_type)
      @handlers[event_type]
    end

    def log message
      STDOUT.puts message
    end
  end
end
