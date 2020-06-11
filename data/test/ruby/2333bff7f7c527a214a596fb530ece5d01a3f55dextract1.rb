#Before refactor
def customer_purchases
  total_purchases = 0

  # calculate total purchases
  @orders.each do |order|
    total_purchases += order.price
  end

  #print detail
  puts "name: #{@name}"
  puts "amount: #{total_purchases}"
end


# After refactor
def customer_purchases
  total_purchases = calculate_purchases
  print_detail(total_purchases)
end

def calculate_purchases
  total_purchases = 0

  # calculate total purchases
  @orders.each do |order|
    total_purchases += order.price
  end
end

def print_detail(total_purchases)
  #print detail
  puts "name: #{@name}"
  puts "amount: #{total_purchases}"
end