

module Calculate


	def calculate_average(sub1,sub2,sub3)
		print " inside calculate Average"
		
		puts " Average is  #{(sub1+sub2+sub3)/3}"
	end
	def calculate_intrest()
		print " Calculate Interest method"
		@intrest = (@principal*@rate*@time)/100;
		puts "Intrest Calculated as #{@intrest}"
		
	end

end

class Score

	include Calculate
	
end


class Intrest 
	
	include Calculate
	
	def initialize(rate_of_intrest,principal,time)
		#puts " in INIT INTREST "
		@rate=rate_of_intrest.to_f
		@principal =principal.to_i
		@time=time.to_i
		@intrest =0
	end

	
	
end





	intrest = Intrest.new(10,100,1)
	intrest.calculate_intrest()

	score = Score.new()	
	score.calculate_average(90,90,87)

