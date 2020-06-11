module Connfu
  class EventProcessor
    include Connfu::Logging

    attr_reader :handler_class

    def initialize(handler_class)
      @handler_class = handler_class
    end

    def handle_event(event)
      if handler = handler_for(event)
        handler.handle_event(event)
      elsif event.is_a?(Connfu::Event::Offer) || event.is_a?(Connfu::Event::Ringing)
        handler = build_handler(event)
        handlers << handler
        handler.handle_event(event)
      end
      remove_finished_handlers
    end

    def handlers
      @handlers ||= []
    end

    private

    def build_handler(event)
      @handler_class.new(:from => event.presence_from, :to => event.presence_to, :call_id => event.call_id)
    end

    def handler_for(event)
      handlers.detect do |h|
        h.can_handle_event?(event)
      end
    end

    def remove_finished_handlers
      handlers.delete_if(&:finished?)
    end
  end
end