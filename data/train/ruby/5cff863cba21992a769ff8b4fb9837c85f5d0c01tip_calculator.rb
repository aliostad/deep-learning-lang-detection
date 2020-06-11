def calculate_tax
	@order_total * ( @tax_percent * 0.01 )
end

def calculate_tip
	@order_total * ( @tip_percent * 0.01 )
end

def calculate_total
	@order_total + calculate_tax + calculate_tip
end

puts
puts "total of your order? (tax excluded)"
@order_total = gets.chomp.to_f

puts
puts "tax percentage?"
@tax_percent = gets.chomp.to_f

puts
puts "tip percent?"
@tip_percent = gets.chomp.to_f

puts
puts "calculating...."

puts "Your tax is $#{calculate_tax}"
puts "Your tip is $#{calculate_tip}"
puts "Your order total is $#{calculate_total}"