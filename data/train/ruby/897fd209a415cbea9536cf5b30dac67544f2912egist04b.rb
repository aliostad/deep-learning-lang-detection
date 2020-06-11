#!/usr/bin/env ruby
 
class Routes
  
  def initialize
    @distances = {}
  end
  
  def distance(*segments)
    # @distances[segments] ||= calculate_distance(*segments) # => only works if value != nil
    if @distances.has_key?(segments)
      @distances[segments]
    else
      @distances[segments] = calculate_distance(*segments)
    end
  end
  
private  
  def calculate_distance(*segments)
    puts "Expensive Task"
    segments.inject { |sum, val| sum + val }
  end
end  
 
 
r = Routes.new
puts r.distance 1,2,3,4
puts r.distance 1,2,3,4
puts r.distance 9,8,7,6
puts r.distance 9,8,7,6
