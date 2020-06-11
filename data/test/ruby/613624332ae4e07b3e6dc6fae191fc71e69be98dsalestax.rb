class Item
	attr_accessor :price, :tax_rate
	# attr_accessor :tax_rate
	def initialize(price)
		@tax_rate = 0.10
		@price = price
	end

	def calculate_sales_tax
		(((@price * @tax_rate)/0.05).round*0.05).round(2)
	end

	def calculate_total
		@price + calculate_sales_tax
		
	end
	
end

class Exempt < Item
	def initialize(price)
		@tax_rate = 0
		super(price)
	end

	def calculate_sales_tax
		0
	end
		
end

class ImportedItems < Item
	def initialize(price)
		super(tax_rate)
		super(price)
	end
	def calculate_imp_tax
		(((@price * 0.05)/0.05).round*0.05).round(2)
	end
	def calculate_imp_sales_tax
		(((@price * (@tax_rate + 0.05))/0.05).round*0.05).round(2)
	end
	def calc_total_salestx_exempt
		(((@price * 1.05)/0.05).round*0.05).round(2)
	end
	def calc_total
		@price + calculate_imp_sales_tax
	end

end

def round(x)
	round(x * 20) / 20
end


# Output 1:
book = Exempt.new(12.49)
music_cd = Item.new(14.99)
chocolate_bar = Exempt.new(0.85)
puts "1 book : $#{(book.calculate_total).round(2)}"
puts "1 music cd : $#{(music_cd.calculate_total).round(2)}"
puts "1 chocolate bar : $#{chocolate_bar.calculate_total}"
puts "Sales Taxes: $#{(music_cd.calculate_sales_tax).round(2)}"
book_total = book.calculate_total
music_cd_total = music_cd.calculate_total
chocolate_bar_total = chocolate_bar.calculate_total
puts "Total: $#{(book_total + music_cd_total + chocolate_bar_total).round(2)}"
puts " "

# Output 2
imp_chocolates = ImportedItems.new(10.00)
imp_perfume = ImportedItems.new(47.50)

puts "1 imported box of chocolates: $#{(imp_chocolates.calc_total_salestx_exempt).round(2)}"
puts "1 imported bottle of perfume: $#{(imp_perfume.calc_total).round(2)}"
puts "Sales Taxes: $#{(imp_perfume.calculate_sales_tax + imp_perfume.calculate_imp_tax + imp_chocolates.calculate_imp_tax).round(2)}"
puts "Total: $#{(imp_perfume.calc_total + imp_chocolates.calc_total_salestx_exempt).round(2)}"
puts " "

#Output 3
imp_perfume2 = ImportedItems.new(27.99)
perfume = Item.new(18.99)
h_pills = Exempt.new(9.75)
imp_chocolates2 = ImportedItems.new(11.25)

puts "1 imported bottle of perfume: $#{imp_perfume2.calc_total.round(2)}"
puts "1 bottle of perfume: $#{perfume.calculate_total.round(2)}"
puts "1 packet of headache pills: $#{h_pills.calculate_total.round(2)}"
puts "1 imported box of chocolates: $#{imp_chocolates2.calc_total_salestx_exempt}"
puts "Sales Taxes: $#{(imp_perfume2.calculate_imp_tax + imp_perfume2.calculate_sales_tax + perfume.calculate_sales_tax + imp_chocolates2.calculate_imp_tax).round(2)}"
puts "Total: $#{(imp_perfume2.calc_total + perfume.calculate_total + h_pills.calculate_total + imp_chocolates2.calc_total_salestx_exempt).round(2)}"
