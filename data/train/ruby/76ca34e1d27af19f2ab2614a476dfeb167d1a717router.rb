class SuperPoller::Router
  RoutingError = Class.new(Exception)

  def initialize()
    @handlers = []
  end

  def add_handler(handler)
    @handlers.push handler
    @handlers.uniq!
    self
  end

  alias << add_handler

  def call(message)
    handler = best_handler_for_message(message)
    handler.call(message[:body])
  end

protected

  def best_handler_for_message(messsage)
    @handlers.each do |handler|
      return handler if handler.can_handle? messsage
    end
    raise RoutingError, "No handler found"
  end
end
