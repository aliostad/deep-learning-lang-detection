class Order

	attr_accessor :list

	def initialize
		@list = {}
		@total = 0
	end

	def add_lineitem(lineitem)
		@list[lineitem.dish] = lineitem.quantity
		self.calculate_total
	end

	def remove_lineitem(lineitem)
		@list.delete(lineitem.dish)
		self.calculate_total
	end

	def dish_quantity(dish)
		@list[dish]  
	end

	def lineitem_change_quantity(lineitem,new_quantity)
		@list[lineitem.dish] = new_quantity
		self.calculate_total
	end

	def calculate_total
		@total = 0
		@list.each { |dish, quantity| @total += dish.price * quantity}
		@total
	end

	def empty?
		@list.empty?
	end

end