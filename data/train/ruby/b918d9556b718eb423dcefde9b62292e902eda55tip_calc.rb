def ask(question)
  puts question
  answer = gets.chomp
  answer.to_f
end

def calculate_tip(tip_percent, price)
  tip_to_decimal = tip_percent * 0.01
  price * tip_to_decimal
end

def calculate_tax(tax, price)
  price * tax
end

def calculate_total(price, tip_percent)
  tax = calculate_tax(0.045, price)
  tip = calculate_tip(tip_percent, price)
  price + tip + tax
end

price = ask("What is the price?")
tip_percent = ask("How much tip would you like to add?")
meal_total = calculate_total(price, tip_percent)
puts " You should pay $#{meal_total}! "

