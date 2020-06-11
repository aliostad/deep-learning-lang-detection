class Quote

    VEHICLE = {
        bicycle: [1],
        motorbike: [1.2],
        car: [1.3],
        van: [1.4]
  }



  attr_accessor :from, :to, :vehicle

  def initialize(from,to, vehicle)
    @from = from
    @to = to
    @vehicle = vehicle
  end

  def calculate_distance
    from_difference = @from[0] - @from[1]
    to_difference = @to[0] - @to[1]

    result = ((from_difference **2 )- (to_difference **2 )).abs
    result = Math.sqrt(result).to_i

  end

  def calculate_price(result)

    result = result * vehicle[0] 
  end

end




#calculate_price(Vehicle[:bicyle])