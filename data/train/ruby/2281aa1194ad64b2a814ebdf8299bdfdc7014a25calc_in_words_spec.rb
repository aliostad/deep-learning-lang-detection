require('calc_in_words')
require('rspec')

describe('calculate') do
  it('should add two numbers if given numbers and the word "plus"') do
    calculate("5 plus 6").should(eq(11))
  end
  it('should find the operation and perform it on two numbers') do
   calculate("Find 7 minus 3").should(eq(4))
  end
  it('should perform calculation with multiple numbers and operators') do
    calculate("Find 4 plus 10 minus 7").should(eq(7))
  end
  it('should automatically perform any number of arithmetic calculations') do
    calculate("Find 10 divided by 5 multiplied by 3 plus 4").should(eq(10))
  end 
  it('should return floats') do
    calculate("What is 5 divided by 2?").should(eq(2.5))
    end 
  it('should take a float as an input') do
    calculate("What is 4.8 divided by 2").should(eq(2.4))    
  end
  it('should recognize and calculate powers') do 
    calculate("What is 4 to the power of 3").should(eq(64))
  end
end
