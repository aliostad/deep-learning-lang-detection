class CalculateCharge
  attr_reader :hours, :total

  COST_PER_KILOWATT_HOUR  = 10
  THRESHOLD               = 1_000
  BASIC_CHARGE            = 500
  CENTS_IN_A_DOLLAR       = 100

  def initialize(hours)
    @hours  = hours
  end

  def calculate
    calculate_total

    [dollars, cents]
  end

  #######
  private
  #######

  def dollars
    total / CENTS_IN_A_DOLLAR
  end

  def cents
    total % CENTS_IN_A_DOLLAR
  end
  
  def went_over?
    hours > THRESHOLD
  end

  def calculate_total
    @total = [BASIC_CHARGE, overage].reduce(:+)
  end

  def overage
    if went_over?
      calculate_overage
    else
      0
    end
  end

  def calculate_overage
    (hours - THRESHOLD) * COST_PER_KILOWATT_HOUR
  end
end
    