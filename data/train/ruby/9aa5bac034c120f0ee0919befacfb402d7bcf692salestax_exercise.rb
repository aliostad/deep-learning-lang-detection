class SalesTax
        attr_accessor :quantity, :item_name, :price
        def initialize(quantity, item_name, price)
                @quantity = quantity
                @item_name = item_name
                @price = price
        end
end

class ImportDutyOnly < SalesTax #Item pays 5% tax
        def calculate_sales_tax
                @price * 0.05
        end

 def calculate_total
        @price + calculate_sales_tax
        end
end

class LocallyTaxed < SalesTax # Item pays 10% tax 
        def calculate_sales_tax
                @price * 0.1
        end

        def calculate_total
        @price + calculate_sales_tax
        end
end

class TaxExempt < LocallyTaxed #Items pays 0% tax
        def calculate_sales_tax
                0
        end
        
        def calculate_total
                @price
        end
end

class ImportedItemLocalTax < LocallyTaxed  #Item pays 15% tax
        def calculate_sales_tax
                @price * 0.15
        end
end

item1=TaxExempt.new(1, "book", 12.49)
puts "#{item1.quantity} #{item1.item_name}: #{item1.calculate_total}"
item2=LocallyTaxed.new(1,"music CD",14.99)
puts "#{item2.quantity} #{item2.item_name}: #{item2.calculate_total}"
item3=TaxExempt.new(1,"chocolate_bar",0.85)
puts "#{item3.quantity} #{item3.item_name}: #{item3.price}"
puts "Sales taxes: #{item1.calculate_sales_tax+item2.calculate_sales_tax+item3.calculate_sales_tax}"
puts "Total: #{item1.calculate_total+ item2.calculate_total+ item3.calculate_total}"
puts ""

item4 = ImportDutyOnly.new(1, "imported box of chocolates", 10.00) 
puts "#{item4.quantity} #{item4.item_name}: #{item4.calculate_total}"
 item5 = ImportedItemLocalTax.new(1,"imported bottle of perfume", 47.50) 
 puts "#{item5.quantity} #{item5.item_name}: #{item5.calculate_total}"
 puts "Sales taxes: #{item4.calculate_sales_tax+item5.calculate_sales_tax}"
 puts "Total: #{item4.calculate_total+ item5.calculate_total}"
 puts ""
 
item6=ImportedItemLocalTax.new(1,"imported bottle of perfume",27.99)
puts "#{item6.quantity} #{item6.item_name}: #{item6.calculate_total}"
item7=LocallyTaxed.new(1,"bottle of perfume",18.99)
puts "#{item7.quantity} #{item7.item_name}: #{item7.calculate_total}"
item8=TaxExempt.new(1,"packet of headache pills",9.75)
puts "#{item8.quantity} #{item8.item_name}: #{item8.calculate_total}"
item9=ImportDutyOnly.new(1, "imported box of chocolates",11.25) 
puts "#{item9.quantity} #{item9.item_name}: #{item9.calculate_total}"
puts "Sales taxes: #{item6.calculate_sales_tax+item7.calculate_sales_tax+item8.calculate_sales_tax+item9.calculate_sales_tax}"
puts "Total: #{item6.calculate_total+ item7.calculate_total+item8.calculate_sales_tax+item9.calculate_sales_tax}"
puts ""