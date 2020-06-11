require_relative 'calculator'

describe Calculator do
  let(:calculator) {  Calculator.new }

  it "returns 0 for an empty string" do
    result = calculator.calculate("")
    
    result.should == 0
  end
  
  it "returns 1 for a string containing 1" do
    result = calculator.calculate("1")
    
    result.should == 1    
  end
  
  it "returns the sum of the numbers for '1,2'" do
    result = calculator.calculate("1,2")
    
    result.should == 3        
  end
  
  it 'can add unknown amount of numbers' do
    result = calculator.calculate("1,2,3,4")
    
    result.should == 10           
  end
  
  it 'allows new line also as a delimiter' do
    result = calculator.calculate("1\n2,3")
    
    result.should == 6
  end
  
  it 'supports different delimiters' do
    result = calculator.calculate("//;\n1;2")
    
    result.should == 3    
  end
end