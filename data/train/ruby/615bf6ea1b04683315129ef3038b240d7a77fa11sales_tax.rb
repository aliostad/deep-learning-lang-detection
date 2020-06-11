#===================
#     CLASSES
#===================


class Goods
attr_accessor :quantity, :name, :price

	def initialize(quantity, name, price)
		@quantity = quantity
		@price = price
		@name = name
	end

#Tax should be 10%
	def calculate_tax
		@price * 0.1
	end



	def calculate_total
		@price + calculate_tax
	end

end

#=======================
#The following three methods override calculate_tax


class ExemptGoods < Goods

#Tax is 0%
	def calculate_tax
		@price * 0
	end
end


class ImportedGoods < Goods

#Tax is 15%
	def calculate_tax
		@price * 0.15
	end

end



class ExemptImportedGoods < Goods

#Tax is 5%
	def calculate_tax
		@price * 0.05
	end

end

#===================
#     INPUT 
#===================

book = ExemptGoods.new(1, "book", 12.49)
music_cd = Goods.new(1, "music CD", 14.99)
chocolate_bar = ExemptGoods.new(1, "chocolate bar", 0.85)

imported_chocolates1 = ExemptImportedGoods.new(1, "imported box of chocolates", 10.00)
imported_perfume1 = ImportedGoods.new(1, "imported bottle of perfume", 47.50)

imported_perfume2 = ImportedGoods.new(1, "imported bottle of perfume", 27.99)
domestic_perfume = Goods.new(1, "bottle of perfume", 18.99)
pills = ExemptGoods.new(1, "packet of headache pills", 9.75)
imported_chocolates2 = ExemptImportedGoods.new(1, "box of imported chocolates", 11.25)


puts
puts "INPUT:"
puts
puts "Input 1:"
puts "#{book.quantity} #{book.name} at $#{book.price}"
puts "#{music_cd.quantity} #{music_cd.name} at $#{music_cd.price}"
puts "#{chocolate_bar.quantity} #{chocolate_bar.name} at $#{chocolate_bar.price}"
puts
puts "Input 2:"
puts "#{imported_chocolates1.quantity} #{imported_chocolates1.name} at $#{imported_chocolates1.price}"
puts "#{imported_perfume1.quantity} #{imported_perfume1.name} at $#{imported_perfume1.price}"
puts 
puts "Input 3:"
puts "#{imported_perfume2.quantity} #{imported_perfume2.name} at $#{imported_perfume2.price}"
puts "#{domestic_perfume.quantity} #{domestic_perfume.name} at $#{domestic_perfume.price}"
puts "#{pills.quantity} #{pills.name} at $#{pills.price}"
puts "#{imported_chocolates2.quantity} #{imported_chocolates2.name} at $#{imported_chocolates2.price}"
puts

#===================
#     OUTPUT
#===================
 
puts
puts "OUTPUT"
puts
puts "Output 1:"
puts "#{book.quantity} #{book.name} at $#{book.calculate_total}"
puts "#{music_cd.quantity} #{music_cd.name} at $#{music_cd.calculate_total.round(2)}"
puts "#{chocolate_bar.quantity} #{chocolate_bar.name} at $#{chocolate_bar.calculate_total}"
puts "Sales Taxes: $ #{(book.calculate_tax + music_cd.calculate_tax + chocolate_bar.calculate_tax).round(2)}"
puts "Total: $#{(book.calculate_total + music_cd.calculate_total + chocolate_bar.calculate_total).round(2)}"
puts
puts "Output 2:"
puts "#{imported_chocolates1.quantity} #{imported_chocolates1.name} at $#{imported_chocolates1.calculate_total}"
puts "#{imported_perfume1.quantity} #{imported_perfume1.name} at $#{imported_perfume1.calculate_total}"
puts "Sales Taxes: $ #{(imported_chocolates1.calculate_tax + imported_perfume1.calculate_tax).round(2)}"
puts "Total: $#{(imported_chocolates1.calculate_total + imported_perfume1.calculate_total).round(2)}"
puts
puts "Output 3:"
puts "#{imported_perfume2.quantity} #{imported_perfume2.name} at $#{imported_perfume2.calculate_total}"
puts "#{domestic_perfume.quantity} #{domestic_perfume.name} at $#{domestic_perfume.calculate_total}"
puts "#{pills.quantity} #{pills.name} at $#{pills.calculate_total}"
puts "#{imported_chocolates2.quantity} #{imported_chocolates2.name} at $#{imported_chocolates2.calculate_total}"
puts "Sales Taxes: $ #{(imported_perfume2.calculate_tax + domestic_perfume.calculate_tax + pills.calculate_tax + imported_chocolates2.calculate_tax).round(2)}"
puts "Total: $#{(imported_perfume2.calculate_total + domestic_perfume.calculate_total + pills.calculate_total + imported_chocolates2.calculate_total).round(2)}"




#=================================
#     NOTES FROM CODE REVIEW
#===================


# change tax rate to a reader in the Goods class.
# We don't want anyone to be able to override that.
# attn_reader :tax_rate
# It's the same calculation...
# attn_reader creates a method for us. Put it in Goods, 
# then override it in the child CLASSES
# e.g.
# def tax_rate
# 	0.05
# end

# then you don't need calculate tax_rate method in each class,
# because you can just modify the def.

# This way, your math is isolated in one spot. If there's a bug,
# you'll be able to find it easily.

# all the methods are localized in the base class. 
# Put all default functionality in base class. 
# Localized all logic in base class and only override 
# things in the child classes that change.