class TestableClass1
  def calculate(n)
    return n
  end
end

class TestableClass2
  attr_accessor :divisor_1, :divisor_2

  def initialize(div1=3, div2=5)
    divisor_1 = div1
    divisor_2 = div2
  end

  def calculate(n)
    a = (0..(n-1)).to_a.select do |i|
      i.modulo(divisor_1 || 3) == 0 || i.modulo(divisor_2 || 5) == 0
    end
    a.inject(:+)
  end
end

class TestableClass3
  def calculate(n)
    a = (1..n).to_a.inject(0) { |i,j| i+j*j }
    b = (1..n).to_a.inject(0) { |i,j| i+j }
    b*b-a
  end
end

# calculate fibonacci number
class TestableClass4
  def calculate(n)
    return n if (0..1).include? n
    calculate(n-1) + calculate(n-2) if n > 1
  end
end