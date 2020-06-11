class StripeWebhookHandler
  class NoHandlerError < StandardError; end

  attr_reader :event

  def initialize(event)
    @event = event
  end

  def handle_webhook
    call_handler_method
  rescue NoHandlerError => e
    # Do nothing
  end

  private

  # @return [String]
  def type
    event.type
  end

  # @return [Array<String>]
  def parts_of_event_type
    @parts_of_event_type ||= ['stripe_webhook', type.split('.')].flatten
  end

  # @return [String]
  def handler_class
    @handler_class ||= "#{parts_of_event_type[0...-1].join('/').camelize}Handler"
  end

  # @return [String]
  def handler_method
    @handler_method ||= parts_of_event_type[-1].to_sym
  end

  # @return [Class]
  def handler
    handler_class.constantize
  rescue NameError
    raise NoHandlerError.new
  end

  # Returns a new instance of the handler
  def new_handler
    handler.new(event)
  end

  def call_handler_method
    new_handler.send(handler_method) if handler.method_defined?(handler_method)
  end
end
