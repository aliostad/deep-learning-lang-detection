require 'rubygems'

# START:calculate_time
require 'fit/column_fixture'
require 'calculator'

class CalculateTime < Fit::ColumnFixture
  def initialize
    @calc = Calculator.single
    @days = @hours = @mins = @secs = nil
  end
end
# END:calculate_time

# START:time_accessors 
class CalculateTime
  attr_accessor :days, :hours, :mins
  attr_reader :secs

  def secs=(value)
    @secs = value
    
    @calc.enter_time @days, @hours, @mins, @secs
    @calc.plus
    @calc.enter_number 0
    @calc.equals
    
    @days, @hours, @mins, @secs = @calc.time
  end
end
# END:time_accessors
