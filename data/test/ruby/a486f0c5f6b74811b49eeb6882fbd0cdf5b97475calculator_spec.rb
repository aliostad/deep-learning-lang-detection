require 'spec_helper'

module ProductTable

  describe Calculator do

    describe "#calculate_primes" do

      it "should return a list of n prime numbers" do
        Calculator.calculate_primes(5).should == [2,3,5,7,11]
      end

    end

    describe "#calculate_product" do

      it "should return a product table of a number list" do
        product_table = Calculator.calculate_product([2,2,3])
        product_table.should == [
          [4,4,6],
          [4,4,6],
          [6,6,9]
        ]
      end

    end

  end

end
