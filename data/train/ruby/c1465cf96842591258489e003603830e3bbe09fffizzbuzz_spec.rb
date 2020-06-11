require 'rspec'
require 'fizzbuzz.rb'

describe 'fizzbuzz calculator' do 
     before do 
       @calculator = Calculator.new 
     end
     it 'returns 1 from 1' 
         @calculator.calculate(1).should == 1 
     end    
     it 'returns 2 from 2' 
         @calculator.calculate(2).should == 2 
     end    
     it 'returns from 3' 
         @calculator.calculate(3).should == 'fizz' 
     end    
    it 'returns 4 from 4' 
         @calculator.calculate(4).should == 4 
     end    
    it 'returns from 5' 
         @calculator.calculate(5).should == 'buzz' 
     end    
    it 'returns from 6' 
         @calculator.calculate(6).should == 'fizz'
     end    
     it 'returns from 10' 
         @calculator.calculate(10).should == 'buzz'
     end    
     it 'returns from 15' 
         @calculator.calculate(15).should == 'fizzbuzz'
     end    
     