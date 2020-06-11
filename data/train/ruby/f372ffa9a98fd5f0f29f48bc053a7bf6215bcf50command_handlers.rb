class CommandHandlers
  include Aftermath::Handler, Aggregates

  def self.handler(h)
    require "command_handlers/#{h.to_s.to_underscore}"
    include const_get(h)
    handlers << h
  end

  def self.handlers
    @handlers ||= []
  end

  handler :UpdateCartQuantity
  handler :AddCouponToCart
  handler :AddProductToCart
  handler :ClearCart
  handler :CreateCart
  handler :RemoveCouponFromCart
  handler :RemoveProductFromCart

  handler :AddInventory
  handler :RelocateInventory
  handler :RemoveInventory

  handler :CategorizeProduct
  handler :ModifyProductSku
  handler :RenameProduct
  handler :CreateProduct

  handler :CreateOrder
  handler :AddProductToOrder
  handler :CancelOrder
  handler :HoldOrder
  handler :RemoveProductFromOrder
  handler :ShipOrder
  handler :UpdateOrderQuantity
  handler :CreateInventory

  def initialize(repository)
    @repository = repository
  end

  def handle(msg)
    if Aftermath.tracing?
      puts "\n---------- begin consistency boundary ----------"
      puts "=> #{msg.inspect}"
    end
    super
  end
  alias << handle

  private
  def repository; @repository; end
end