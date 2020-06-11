class Item
	attr_reader :qty, :item, :price
	def initialize(qty, item, price)
		@qty = qty
		@item = item
		@price = price
		@tax_rate = 0.10
	end

	def calculate_sales_tax
		@price * @tax_rate
	end
	
	def calculate_sales_total
		@price + calculate_sales_tax
	end
end

class ExemptItem < Item
	def calculate_sales_tax
		0
	end
	
	def calculate_sales_total
		@price + calculate_sales_tax
	end
end

class ImportedItem < Item
		def calculate_sales_tax
		@price * (@tax_rate+0.05)
	end
	
	def calculate_sales_total
		@price + calculate_sales_tax
	end
end

class ImportedExemptItem < Item
	def calculate_sales_tax
		@price * 0.05
	end
	
	def calculate_sales_total
		@price + calculate_sales_tax
	end
end

# Input 1
input1a = ExemptItem.new(1, "book", 12.49)
input1b = Item.new(1, "music CD", 14.99)
input1c = ExemptItem.new(1, "chocolate bar", 0.85)

# Output 1
puts "Output 1:"
puts "#{input1a.qty} #{input1a.item}: #{input1a.calculate_sales_total}"
puts "#{input1b.qty} #{input1b.item}: #{input1b.calculate_sales_total}"
puts "#{input1c.qty} #{input1c.item}: #{input1c.calculate_sales_total}"
puts "Sales Taxes: #{input1a.calculate_sales_tax+input1b.calculate_sales_tax+input1c.calculate_sales_tax}"
puts "Total: #{input1a.calculate_sales_total+input1b.calculate_sales_total+input1c.calculate_sales_total}"
puts ""

# Input 2
input2a = ImportedExemptItem.new(1, "imported box of chocolates", 10.00)
input2b = ImportedItem.new(1, "imported bottle of perfume", 47.50)

# Output 2
puts "Output 2:"
puts "#{input2a.qty} #{input2a.item}: #{input2a.calculate_sales_total}"
puts "#{input2b.qty} #{input2b.item}: #{input2b.calculate_sales_total}"
puts "Sales Taxes: #{input2a.calculate_sales_tax+input2b.calculate_sales_tax}"
puts "Total: #{input2a.calculate_sales_total+input2b.calculate_sales_total}"
puts ""

# Input 3
input3a = ImportedItem.new(1, "imported bottle of perfume", 27.99)
input3b = Item.new(1, "bottle of perfume", 18.99)
input3c = ExemptItem.new(1, "packet of headache pills", 9.75)
input3d = ImportedExemptItem.new(1, "box of imported chocolates", 11.25)

# Output 3
puts "Output 3:"
puts "#{input3a.qty} #{input3a.item}: #{input3a.calculate_sales_total}"
puts "#{input3b.qty} #{input3b.item}: #{input3b.calculate_sales_total}"
puts "#{input3c.qty} #{input3c.item}: #{input3c.calculate_sales_total}"
puts "#{input3d.qty} #{input3d.item}: #{input3d.calculate_sales_total}"
puts "Sales Taxes: #{input3a.calculate_sales_tax+input3b.calculate_sales_tax+input3c.calculate_sales_tax+input3d.calculate_sales_tax}"
puts "Total: #{input3a.calculate_sales_total+input3b.calculate_sales_total+input3c.calculate_sales_total+input3d.calculate_sales_total}"
