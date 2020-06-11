class ExtractMethod

  def print_owing
    outstanding = 0.0

    pritn_banner

    #calculate stading
    @order.each do |order|
      outstanding += order.amount
    end

    print_details outstading

    def print_details(outstanding)
      puts "name: #{@name}"
      puts "amount: #{@outstading}"
    end

end
#extract calculaion
def calculate_outstanding
  outstanding = 0.0
  @orders.each do |order|
    outstading += order.amount
  end
  outstading
end

#closure
def calculate_method_clojure
  @orders.inject(0,0) { |resul, order| result += order.amount}
end
