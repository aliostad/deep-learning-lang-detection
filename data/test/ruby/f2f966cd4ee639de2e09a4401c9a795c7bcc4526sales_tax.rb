class SalesTax
	attr_accessor :qty, :name, :price
	def initialize(qty, name, price)
		@qty = qty
		@name = name
		@price = price
	end
end


class TaxExemptImport < SalesTax
        def calculate_sales_tax
             (@price * 0.05).round(2)
        end
        def calculate_total
            (@price + calculate_sales_tax).round(2)
        end
end

class TaxExempt < SalesTax
        def calculate_sales_tax
            @price * 1
        end
        def calculate_total
            @price.round(2)
        end
end

class TaxAndDuty < SalesTax
        def calculate_sales_tax
            (@price * 0.15).round(2)
        end
        def calculate_total
        	(@price + calculate_sales_tax).round(2)
        end
end

class TaxOnly < SalesTax
    	def calculate_sales_tax
      	(@price * 0.10).round(2)
    	end
		def calculate_total
        (@price + calculate_sales_tax).round(2)
    	end
end


puts "Output 1:"
book = TaxExempt.new(1, "book", 12.49)
puts "#{book.qty} #{book.name}: #{book.calculate_total}"

music = TaxOnly.new(1, "music CD", 14.99)
puts "#{music.qty} #{music.name}: #{music.calculate_total}"

chocolate_bar = TaxExempt.new(1, "chocolate bar", 0.85)
puts "#{chocolate_bar.qty} #{chocolate_bar.name}: #{chocolate_bar.calculate_total}"

puts "Sales Taxes: #{book.calculate_sales_tax + music.calculate_sales_tax + chocolate_bar.calculate_sales_tax}"
puts "Total: #{book.calculate_total + music.calculate_total + chocolate_bar.calculate_total}"

puts " "
puts "Output 2:"

imported_chocolate = TaxExemptImport.new(1, "imported box of chocolates", 10.00)
puts "#{imported_chocolate.qty} #{imported_chocolate.name}: #{imported_chocolate.calculate_total}"

imported_perfume = TaxAndDuty.new(1, "imported bottle of perfume", 47.50)
puts "#{imported_perfume.qty} #{imported_perfume.name}: #{imported_perfume.calculate_total}"

puts "Sales Taxes: #{imported_chocolate.calculate_sales_tax + imported_perfume.calculate_sales_tax}"
puts "Total: #{imported_chocolate.calculate_total + imported_perfume.calculate_total}"


puts " "
puts "Output 3:"

imported_perfume2 = TaxAndDuty.new(1, "imported bottle of perfume", 27.99)
puts "#{imported_perfume2.qty} #{imported_perfume2.name}: #{imported_perfume2.calculate_total}"

perfume = TaxOnly.new(1, "bottle of perfume", 18.99)
puts "#{perfume.qty} #{perfume.name}: #{perfume.calculate_total}"

headache_pills = TaxExempt.new(1, "headache_pills", 9.75)
puts "#{headache_pills.qty} #{headache_pills.name}: #{headache_pills.calculate_total}"

imported_chocolate2 = TaxExemptImport.new(1, "imported box of chocolates", 11.25)
puts "#{imported_chocolate2.qty} #{imported_chocolate2.name}: #{imported_chocolate2.calculate_total}"

puts "Sales Taxes: #{imported_perfume2.calculate_sales_tax + perfume.calculate_sales_tax + headache_pills.calculate_sales_tax + imported_chocolate.calculate_sales_tax}"
puts "Total: #{imported_perfume2.calculate_total + perfume.calculate_total + headache_pills.calculate_total + imported_chocolate.calculate_total}"





