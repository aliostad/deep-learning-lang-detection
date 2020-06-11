module SimpleCQRS
  class FakeBus
    def initialize
      @routes = Hash.new{|h,k| h[k] = [] }
    end

    def register_event_handler(event_class, handler)
      @routes[event_class] << handler
    end

    def register_command_handler(command_class, handler)
      @routes[command_class] << handler
    end

    def send_command(command)
      handlers = @routes.fetch(command.class) { raise "No handler registered" }
      raise "Cannot send to more than one handler" if handlers.length != 1
      handlers.first.handle(command)
    end

    def publish(event)
      @routes[event.class].each do |handler|
        handler.handle(event)
      end
    end
  end
end
