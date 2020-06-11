class Restaurant_Bill

	attr_accessor :cost_of_meal, :tax_percentage, :tip_percentage
	
	# constructor method
	def initialize
		@cost_of_meal
		@tax_percentage
		@tip_percentage
	end

	# instance methods
	def getValue(string_request)
		puts string_request
		value_requested_s = gets
		value = Float(value_requested_s)
	end

	def getCostOfMeal
		@cost_of_meal = self.getValue("Enter the cost of your meal before tax:")
	end

	def getTaxPercentage
		@tax_percentage = self.getValue("Enter the tax in percentage:")
	end

	def getTipPercentage
		@tip_percentage = self.getValue("Enter the tip in percentage:")
	end

	def calculateValue(base_amount, percentage)
		value = base_amount * (percentage / 100.00)
	end

	def calculateTaxValue
		tax_value = calculateValue(@cost_of_meal, @tax_percentage)
	end

	def calculateMealWithTax
		meal_with_tax = @cost_of_meal + self.calculateTaxValue
	end

	def calculateTipValue
		tip_value = calculateValue(self.calculateMealWithTax, @tip_percentage)
	end

	def calculateTotalCost
		total_cost_of_meal = self.calculateMealWithTax + self.calculateTipValue
	end

	def printReceipt
		puts "The pre-tax cost of your meal was $" + sprintf('%.2f', @cost_of_meal)
		puts "At " + sprintf('%.f', @tax_percentage) + "%, tax for this meal is $" + sprintf('%.2f', self.calculateTaxValue) + "."
		puts "For a " + sprintf('%.f', @tip_percentage) + "% tip, you should leave $" + sprintf('%.2f', self.calculateTipValue) + "."
		puts "The grand total for this meal is then $" + sprintf('%.2f', self.calculateTotalCost) + "."
	end
end

my_bill = Restaurant_Bill.new
my_bill.getCostOfMeal
my_bill.getTaxPercentage
my_bill.getTipPercentage
my_bill.calculateTaxValue
my_bill.calculateMealWithTax
my_bill.calculateTipValue
my_bill.calculateTotalCost
my_bill.printReceipt