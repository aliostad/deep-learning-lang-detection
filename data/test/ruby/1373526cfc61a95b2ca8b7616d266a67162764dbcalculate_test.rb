require File.dirname(__FILE__) + '/test_helper'

describe Calculator do
  describe "#calculate" do

# HAPPY PATH

    it 'can add 2 values or more' do
      Calculator.calculate('PLUS 1 2'    ).must_equal tbi(1+2)
      Calculator.calculate('PLUS 1 2 3 4').must_equal tbi(1+2+3+4)
    end

    it 'can subtract 2 values or more' do
      Calculator.calculate('MINUS 10 2'    ).must_equal tbi(10-2)
      Calculator.calculate('MINUS 10 2 3 4').must_equal tbi(10-2-3-4)
    end

    it 'can add 2 multiply 2 values or more' do
      Calculator.calculate('TIMES 1 2'    ).must_equal tbi(1*2)
      Calculator.calculate('TIMES 1 2 3 4').must_equal tbi(1*2*3*4)
    end

    it 'can divide 2 multiply 2 values or more' do
      Calculator.calculate('DIVIDE 100 2'  ).must_equal tbi(100/2)
      Calculator.calculate('DIVIDE 100 2 5').must_equal tbi(100/2/5)
    end

  end

end