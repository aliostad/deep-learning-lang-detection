class Item
    attr_accessor :quantity, :price, :product, :tax_rate
    def initialize(quantity,product,price)
        @quantity = quantity
        @product = product
        @price = price
        @tax_rate = 0.10
    end
    
    def calculate_sales_tax
        @tax_rate*@price
    end
    
    def calculate_total
        @price+calculate_sales_tax
    end
end

class Import < Item
    def calculate_sales_tax
        @price*0.15
    end
    
    def calculate_total
        @price+calculate_sales_tax
    end
end

class Exempt < Item
    def calculate_sales_tax
        0
    end
    
    def calculate_total
        @price+calculate_sales_tax
    end
end

class ImportExempt < Item
    def calculate_sales_tax
        @price*0.05
    end
    
    def calculate_total
        @price+calculate_sales_tax
    end
end
puts "Input 1:"
puts "1 book at 12.49"
puts "1 chocolate bar at 0.85"

puts "Input 2:"
puts "1 imported box of chocolates at 10.00"
puts "1 imported bottle of perfume at 47.50"

puts "input 3"
puts "1 imported bottle of perfume at 27.99"
puts "bottle of perfume at 18.99"
puts "1 packet of headache pills at 9.75"
puts "1 box of imported chocolates at 11.25"

puts "Output 1"
input1 = Exempt.new(1,"book", 12.49)
puts "#{input1.quantity} #{input1.product} : #{input1.calculate_total}"
input1a = Item.new(1,"music CD",14.99)
puts "#{input1a.quantity} #{input1a.product} : #{input1a.calculate_total}"
input1b = Exempt.new(1,"chocolate bar", 0.85)
puts "#{input1b.quantity} #{input1b.product} : #{input1b.calculate_total}"
puts "Sales Taxes : " + "#{input1.calculate_sales_tax+input1a.calculate_sales_tax+input1b.calculate_sales_tax}"
puts "Total : " + "#{input1.calculate_total+input1a.calculate_total+input1b.calculate_total}"
##Output2
puts "Output 2"
input2 = ImportExempt.new(1,"imported box of chocolates",10.00)
puts "#{input2.quantity}" + " #{input2.product} :" + " #{input2.calculate_total}" 
input2a = Import.new(1,"imported bottle of perfume",47.50)
puts "#{input2a.quantity} #{input2a.product} : #{input2a.calculate_total}"
puts "Sales Taxes : #{input2a.calculate_sales_tax+input2.calculate_sales_tax}"
puts "Total : #{input2.calculate_total+input2a.calculate_total}"

##Output3
puts "Output 3"
input3 = Import.new(1,"imported bottle of perfume",27.99)
puts "#{input3.quantity} #{input3.product} : #{input3.calculate_total}"
input3a = Item.new(1,"bottle of perfume at",18.99)
puts "#{input3a.quantity} #{input3a.product} : #{input3a.calculate_total}"
input3b = Exempt.new(1,"packet of headache pills",9.75)
puts "#{input3b.quantity} #{input3b.product} : #{input3b.calculate_total}"
input3c = ImportExempt.new(1,"box of imported chocolates",11.25)
puts "#{input3c.quantity} #{input3c.product} : #{input3c.calculate_total}"
puts "Sales Taxes : #{input3.calculate_sales_tax+input3a.calculate_sales_tax+input3b.calculate_sales_tax+input3c.calculate_sales_tax}"
puts "Total : #{input3.calculate_total+input3a.calculate_total+input3b.calculate_total+input3c.calculate_total}"


