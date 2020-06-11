require 'spec_helper'

module ReversePolishCalculator
  describe Inputs do
    let(:inputs) { [].extend(described_class) }
    
    describe '#calculate' do
      context 'given inputs: 2 2 +' do
        before { add_inputs('2 2 +') }
        
        it 'returns 4.0' do
          inputs.calculate.should eq(4.0)
        end
      end
      
      context 'given inputs: 2 +' do
        before { add_inputs('2 +') }
        
        it 'returns 2.0' do
          inputs.calculate.should eq(2.0)
        end
      end
      
      context 'given inputs: 2 2 2 + +' do
        before { add_inputs('2 2 2 + +') }
        
        it 'returns 6.0' do
          inputs.calculate.should eq(6.0)
        end
      end
      
      context 'given inputs: 2 2 + +' do
        before { add_inputs('2 2 + +') }
        
        it 'returns 4.0' do
          inputs.calculate.should eq(4.0)
        end
      end
      
      context 'given inputs: -1 acos' do
        before { add_inputs('-1 acos') }
        
        it 'returns 3.141592653589793' do
          inputs.calculate.should eq(3.141592653589793)
        end
      end
      
      context 'given inputs: cos' do
        before { add_inputs('cos') }
        
        context 'and an aggregate of 3.0' do
          it 'returns 2.010007503399555' do
            inputs.calculate(3.0).should eq(2.010007503399555)
          end
        end
      end
    end
    
    describe '#inspect' do
      before { add_inputs('1 2') }
      specify { inputs.inspect.should eq('1.0, 2.0') }
    end
    
    def add_inputs(expression)
      expression.split.each do |input|
        inputs << Input.new(input)
      end
    end
    
  end
end