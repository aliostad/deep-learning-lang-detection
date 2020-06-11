module Protocols
  HandlerKey = Struct.new(:klass, :action)

  class Registry
    include Singleton

    def initialize
      @handlers = {}
      register_handler(Person, :update, ::Protocols::Amqp::PersonUpdateHandler)
    end

    def handlers_for(obj, action)
      handler_def = HandlerKey.new(obj.class, action)
      fetch_handlers(handler_def).map(&:new)
    end

    def fetch_handlers(handler_def)
      @handlers.fetch(handler_def)
    end

    def register_handler(cls, action, handler)
      handler_def = HandlerKey.new(cls, action)
      register_handler_key(handler_def, handler)
    end

    def register_handler_key(handler_def, handler)
      if @handlers.has_key?(handler_def)
        @handlers[handler_def] = @handlers[handler_def] + [handler]
      else
        @handlers[handler_def] = [handler]
      end
    end

    def self.handlers_for(obj, action)
      self.instance.handlers_for(obj, action)
    end
  end

  class Notifier
    include Singleton

    def update_notification(obj, delta)
      Registry.handlers_for(obj, :update).each do |handler|
        unless delta.empty?
          handler.handle_update(obj, delta)
        end
      end
    end

    def self.update_notification(obj, delta)
      self.instance.update_notification(obj, delta)
    end
  end
end
