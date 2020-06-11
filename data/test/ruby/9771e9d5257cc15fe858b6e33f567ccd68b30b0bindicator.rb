require "./lib/array"

class Indicator
	include Enumerable

	def initialize(stock)
		@stock = stock
	end
	
	def each
		@indicator.each { |value| yield value }
	end
	
	#要素がnil の時は :no_value をthrowする
	
	def [] (index)
		if index.kind_of? Numeric and
				(@indicator[index].nil? or index < 0 )
			throw :no_value
		else
			@indicator[index]
		end
	end

	def calculate
		@indicator = calculate_indicator
		self
	end
	
	#指標計算の実装。子クラスでオーバライド
	def calculate_indicator; end
end
