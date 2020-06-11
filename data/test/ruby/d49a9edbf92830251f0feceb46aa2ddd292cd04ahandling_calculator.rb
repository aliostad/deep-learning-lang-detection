class HandlingCalculator

  # USPS Media Mail (TODO: Dynamic Calculation)
  DOMESTIC_BASE  = 369
  DOMESTIC_POUND = 95

  # Packing Materials
  BOX_COST  = 150
  TAPE_COST = 10

  # Payment Gateway
  GATEWAY_PERCENT = 0.03
  GATEWAY_CHARGE  = 30
  GATEWAY_MINIMUM = 50

  attr_reader :total, :shipping_rate, :packing_rate, :gateway_rate, :donation_rate

  def initialize(order)
    @order  = order
    @total  = 0
    @donate = 0
  end

  def donate(amount=0)
    @donate = amount
  end

  def calculate
    @total  = calculate_shipping
    @total += calculate_packing
    @total += calculate_payment_gateway
    @total += calculate_donation
  end

  def calculate_shipping
    @shipping_rate  = DOMESTIC_BASE
    @shipping_rate += @order.items.count * DOMESTIC_POUND

    @shipping_rate
  end

  def calculate_packing
    @packing_rate  = BOX_COST
    @packing_rate += TAPE_COST

    @packing_rate
  end

  def calculate_payment_gateway
    @gateway_rate  = @total * GATEWAY_PERCENT
    @gateway_rate += GATEWAY_CHARGE

    @gateway_rate  = GATEWAY_MINIMUM if GATEWAY_MINIMUM > @gateway_rate

    @gateway_rate
  end

  def calculate_donation
    @donation_rate = @donate

    @donation_rate
  end


end
