#In IRB, go require './exercise2b.rb'
#THIS WON'T WORK!!!! >:(

class SalesTax
	attr_accessor :item, :price, :type, :taxduty, :import
	
	def initialize(item, price, type, import)
		@item = item
		@price = price
		@type = type
		@import = import

		if type == "normal"
			@taxduty = 0.1
		elsif type == "exempt"
			@taxduty = 0
		elsif type == "import"
			@taxduty = 0.15
		else
			puts "Error - item type not recognized (must be 'normal', 'exempt', or 'import')"
		end

		if import == "true"
			@taxduty += 0.05
		elsif import == "false"

		else
			puts "Error - import must be true or false"
		end
	end

	def calculate_sales_tax
		@price * @taxduty
	end

	def calculate_total
		@price + calculate_sales_tax
	end

end

book = SalesTax.new("Book", 12.49, "exempt", "false")
book.calculate_sales_tax
book.calculate_total

music = SalesTax.new("Music CD", 14.99, "normal", "false")
music.calculate_sales_tax
music.calculate_total

chocolate = SalesTax.new("Chocolate Bar", 0.85, "exempt", "false")
chocolate.calculate_sales_tax
chocolate.calculate_total


list1 = {{book.item => book.price} => {book.calculate_sales_tax.round(2) => book.calculate_total.round(2)}, 
       {music.item => music.price} => {music.calculate_sales_tax.round(2) => music.calculate_total.round(2)},
   	   {chocolate.item => chocolate.price} => {chocolate.calculate_sales_tax.round(2) => chocolate.calculate_total.round(2)}}

list1.each do |x,y, x2, y2|
	puts "Name: #{x}  Price: #{y}  Sales tax: #{x2}  Total:  #{y2}"
end


impchocolate = SalesTax.new("Imported Chocolate", 10.00, "exempt", "true")
impchocolate.calculate_sales_tax
impchocolate.calculate_total

impperfume = SalesTax.new("Imported Perfume", 47.50, "normal", "true")
impperfume.calculate_sales_tax
impperfume.calculate_total


list2 = {{impchocolate.item => impchocolate.price} => {impchocolate.calculate_sales_tax.round(2) => impchocolate.calculate_total.round(2)}, 
        {impperfume.item => impperfume.price} => {impperfume.calculate_sales_tax.round(2) => impperfume.calculate_total.round(2)}}

