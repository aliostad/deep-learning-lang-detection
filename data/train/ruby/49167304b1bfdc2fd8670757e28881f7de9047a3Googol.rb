class Googol
	def initialize
		@googol = Exponent.calculate(10,100)
	end

	def googol
		@googol
	end

	def googols
		Exponent.calculates(10,100)
	end

	def googolplex		
		@googolplex = Exponent.calculate(10,@googol)
	end

	def googolplexs
		Exponent.calculates(10,@googol)
	end

	def googolplexr
		Exponent.calculater(10,@googol)
	end

	def googolplexplex
		@googolplex = Googol.new.googolplex
		@googolplexplex = Exponent.calculate(@googolplex,@googolplex)
	end

	def googolplexplexplex
		@googolplex = Googol.new.googolplex
		@googolplexplex = Googol.new.googolplexplex
		@googolplexplexplex = Exponent.calculate(@googolplexplex,@googolplex)
	end

	def googolplexplexplexplex
		@googolplex = Googol.new.googolplex
		@googolplexplex = Googol.new.googolplexplex
		@googolplexplexplexplex = Exponent.calculate(@googolplexplex,@googolplexplex)
	end

	def self.help
		puts "initialize"
		puts "googol"
		puts "googols"
		puts "googolplex"
		puts "googolplexs"
		puts "googolplexr"
		puts "googolplexplex"
		puts "googolplexplexplex"
		puts "googolplexplexplexplex"
	end
end