require_relative 'the_math_soln'

describe "tip_calculator --> with" do 

	context "$44.95 subtotal, 6.0% tax, 18.0% tip" do 
		it "calculate_tax_amount returns" do
			calculate_tax_amount(44.95,6.0,18.0).round(2).should == 2.7
		end
		it "calculate_total returns" do 
			calculate_total(44.95,6.0,18.0).round(2).should == 47.65
		end		
		it "calculate_tip_amount returns" do 
			calculate_tip_amount(44.95,6.0,18.0).round(2).should == 8.09
		end		
		it "calculate_final_total returns" do 
			calculate_final_total(44.95,6.0,18.0).round(2).should == 55.74
		end
	end

	context "$68.40 subtotal, 7.5% tax, 25.0% tip" do 
		it "calculate_tax_amount returns" do
			calculate_tax_amount(68.40,7.5,25.0).round(2).should == 5.13
		end
		it "calculate_total returns" do 
			calculate_total(68.40,7.5,25.0).round(2).should == 73.53
		end		
		it "calculate_tip_amount returns" do 
			calculate_tip_amount(68.40,7.5,25.0).round(2).should == 17.1
		end		
		it "calculate_final_total returns" do 
			calculate_final_total(68.40,7.5,25.0).round(2).should == 90.63
		end
	end

	context "$278.90 subtotal, 4.3% tax, 14.0% tip" do 
		it "calculate_tax_amount returns" do
			calculate_tax_amount(278.9,4.3,14.0).round(2).should == 11.99
		end
		it "calculate_total returns" do 
			calculate_total(278.9,4.3,14.0).round(2).should == 290.89
		end		
		it "calculate_tip_amount returns" do 
			calculate_tip_amount(278.9,4.3,14.0).round(2).should == 39.05
		end		
		it "calculate_final_total returns" do 
			calculate_final_total(278.9,4.3,14.0).round(2).should == 329.94
		end
	end
	
	context "$144.56 subtotal, 5.0% tax, 19.0% tip" do 
		it "calculate_tax_amount returns" do
			calculate_tax_amount(144.56,5.0,19.0).round(2).should == 7.23
		end
		it "calculate_total returns" do 
			calculate_total(144.56,5.0,19.0).round(2).should == 151.79
		end		
		it "calculate_tip_amount returns" do 
			calculate_tip_amount(144.56,5.0,19.0).round(2).should == 27.47
		end		
		it "calculate_final_total returns" do 
			calculate_final_total(144.56,5.0,19.0).round(2).should == 179.25
		end
	end

	context "$98.75 subtotal, 6.0% tax, 20.0% tip" do 
		it "calculate_tax_amount returns" do
			calculate_tax_amount(98.75,6.0,20.0).round(2).should == 5.93
		end
		it "calculate_total returns" do 
			calculate_total(98.75,6.0,20.0).round(2).should == 104.68
		end		
		it "calculate_tip_amount returns" do 
			calculate_tip_amount(98.75,6.0,20.0).round(2).should == 19.75
		end		
		it "calculate_final_total returns" do 
			calculate_final_total(98.75,6.0,20.0).round(2).should == 124.43
		end
	end
end