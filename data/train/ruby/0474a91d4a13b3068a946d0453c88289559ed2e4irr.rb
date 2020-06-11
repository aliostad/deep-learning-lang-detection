require 'algebra'

class IRR

  def self.calculate(profits)
    begin
      function(profits).zero
    rescue Algebra::MaximumIterationsReached => mir
      nil
    end
  end

  private

  def self.function(profits)
    Algebra::Function.new do |x|
      sumands = Array.new
      profits.each_with_index {|profit, index| sumands << profit.to_f / (1 + x) ** index }
      sumands.inject(0) {|sum, sumand| sum + sumand }
    end
  end

end

puts IRR.calculate([-100, 30, 35, 40, 45])
puts IRR.calculate([-1, 1])
puts IRR.calculate([-100, 10, 15, 20])
puts IRR.calculate([])
