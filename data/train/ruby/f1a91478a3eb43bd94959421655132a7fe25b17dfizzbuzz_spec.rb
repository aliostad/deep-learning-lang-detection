class FizzBuzz
  def calculate(n)
    if n % 3 == 0 and n % 5 == 0
      "FizzBuzz"
    elsif n % 3 == 0
      "Fizz"
    elsif n % 5 == 0
      "Buzz"
    else
      n
    end
  end
end

describe FizzBuzz, "#calculate" do
  let(:fb) { FizzBuzz.new }
  
  it "returns 'Fizz' for all multiples of 3" do
    fb.calculate(3).should == "Fizz"
  end
  it "returns 'Buzz' for all multiples of 5" do
    fb.calculate(5).should == "Buzz"
  end
  it "returns 'FizzBuzz' for all multiples of 3 and 5" do
    fb.calculate(15).should == "FizzBuzz"
  end
  it "returns the passed number if not a multiple of 3 or 5" do
    fb.calculate(77).should == 77
  end
end
