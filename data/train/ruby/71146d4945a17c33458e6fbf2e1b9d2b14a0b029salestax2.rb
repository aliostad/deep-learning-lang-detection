class SalesTax
	def initialize#(item)
		@tax_rate = 0.13
		@price = price
	end
	
	def calculate_sales_tax
		price * @tax_rate
	end
		#def calculate_tax
		#item.calcualate_tax(@tax_rate)
		#end
	
	def calculate_total
		@price + calculate_sales_tax
	end
end

#class Item
	def initialize(price)
		@price = price
	end

def calculate_tax(tax_rate)	
 	tax_rate * @price
 end
#end

class ImportedBookItem < Book
	def calculate_sales_tax
	 super + @price * 0.05
	end
end

class BookItem < Item
	def calculate_sales_tax
		@price * 0.07
end
end

 chocolate_bar = FoodTax.new
 chocolate_bar.calculate_sales_tax
 chocolate_bar.calculate_total

 teddy_bear = SalesTax.new2