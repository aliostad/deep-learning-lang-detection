class Item
	attr_accessor :quantity, :name, :price, :exempt, :import 

	def initialize(quantity, name, price, exempt, import)
		@quantity = quantity 
		@name = name
		@price = price
		@exempt = exempt
		@import = import
	end

	def calculate_sales_tax
#apply a rate of 10% on specific prices if they are not exempt
		if @exempt
			@sales_tax = 0.0
		else
			@sales_tax = 0.1	
		end

		@price * @sales_tax
	end

	def calculate_total

	end

	def calculate_import_duty
#apply a rate of 5% on all imports
		if @import
			@import_tax = 0.05
		else
			@import_tax = 0.0
		end
	end
end

#shopping basket input 1
chocolate = Item.new(1, "chocolate bar", 0.85, true, false)
music = Item.new(1, "music CD", 14.99, false, false)
book = Item.new(1, "book", 12.49, true, false)

puts "Output 1:"
puts "#{book.quantity} #{book.name} : #{(book.calculate_sales_tax + book.price).round(2)}" 
puts "#{music.quantity} #{music.name} : #{(music.calculate_sales_tax + music.price).round(2)}"
puts "#{chocolate.quantity} #{chocolate.name} : #{(chocolate.calculate_sales_tax + chocolate.price).round(2)}"
puts "Sales Taxes: #{(chocolate.calculate_sales_tax + music.calculate_sales_tax + book.calculate_sales_tax).round(2)}" 
puts "Total: #{(chocolate.price + music.price + book.price + chocolate.calculate_sales_tax + music.calculate_sales_tax + book.calculate_sales_tax).round(2)}"

#shopping basket input 2
importchocolate = Item.new(1, "imported box of chocolates", 10.00, true, true)
importperfume = Item.new(1, "imported bottle of perfume", 47.50, false, true)

puts "Output 2:"
puts "#{importedchocolate.quantity} #{importedchocolate.name} : #{(importedchocolate.calculate_sales_tax + importedchocolate.price).round(2)}"
puts "#{importperfume.quantity} #{importperfume.name} : #{(importperfume.calculate_sales_tax + importperfume.price).round(2)}"
puts "Sales Taxes: #{(importedchocolate.calculate_sales_tax + importperfume.calculate_sales_tax).round(2)}"
puts "Total: #{(importedchocolate.price + importperfume.price + importedchocolate.calculate_sales_tax + importperfume.calculate_sales_tax).round(2)}"

# #shopping basket input 3
importperfume2 = Item.new(1, "imported bottle of perfume", 27.99, false, false)
bottleperfume = Item.new(1, "bottle of perfume", 18.99, false, true)
headachepills = Item.new(1, "packet of headachepills", 9.75, true, false)
importedchocolate1 = Item.new(1, "imported box of chocolates", 11.85, true, true)

puts "Output 3:"
puts "#{importperfume2.quantity} #{importperfume2.name} : #{(importperfume2.calculate_sales_tax + importperfume2.price).round(2)}"
puts "#{bottleperfume.quantity} #{bottleperfume.name} : #{(bottleperfume.calculate_sales_tax + bottleperfume.price).round(2)}"
puts "#{headachepills.quantity} #{headachepills.name} : #{(headachepills.calculate_sales_tax + headachepills.price).round(2)}"
puts "#{importedchocolate1.quantity} #{importedchocolate1.name} : #{(importedchocolate1.calculate_sales_tax + importedchocolate1.price).round(2)}"
puts "Sales Taxes: #{(importperfume2.calculate_sales_tax + bottleperfume.calculate_sales_tax + headachepills.calculate_sales_tax + importedchocolate1.calculate_sales_tax).round(2)}"
puts "Total: #{importperfume2.price + bottleperfume.price + headachepills.price + importedchocolate1.price +importperfume2.calculate_sales_tax + bottleperfume.calculate_sales_tax + headachepills.calculate_sales_tax + importedchocolate1.calculate_sales_tax).round(2)}"
