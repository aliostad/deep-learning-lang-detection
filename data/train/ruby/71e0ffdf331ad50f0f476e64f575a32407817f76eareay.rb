module FinanceEngine
	class EAY_EAR
		def self.calculate_effective_annual_yield(annual_rate, periods)
			(1+annual_rate/periods)**(periods)-1
		end

		def self.calculate_effective_annual_rate(annual_yield, periods)
			((annual_yield + 1)**(1/periods)-1)*periods
		end

		def self.calculate_EAY_payment(amt, rate, time, periods)
			amt * ((1+rate/periods)**(time))
		end

		def self.calculate_EAR_payment(amt, rate, time, periods)
			amt * ((1+rate)**(time.to_f/periods))
		end

		def self.continuous_compounding(amt,rate,time)
			amt * (Math::E**(rate*time))
		end

		def self.compare_EAR_EAY_single_payment(amt,rate,time,periods)
			calculate_EAY_payment(amt, rate, time, periods) - calculate_EAR_payment(amt, rate, time, periods)
		end

		def self.compare_EAR_Continuous_single_payment(amt,rate,time,periods)
			continuous_compounding(amt,rate,time/periods) - calculate_EAR_payment(amt, rate, time, periods)
		end

		def self.compare_EAY_Continuous_single_payment(amt,rate,time,periods)
			continuous_compounding(amt,rate,time/periods) - calculate_EAY_payment(amt, rate, time, periods)
		end
		
		def self.calculate_EAR_series(amt, rate, time, periods)
			sum = 0
			1.upto(time) {|x| sum += calculate_EAR_payment(amt, rate, x, periods)}
			sum
		end

		def self.calculate_EAY_series(amt, rate, time, periods)
			sum = 0
			1.upto(time) {|x| sum += calculate_EAY_payment(amt, rate, x, periods)}
			sum
		end

		def self.calculate_CC_series(amt, rate, time, periods)
			sum = 0
			1.upto(time) {|x| sum += calculate_EAY_payment(amt, rate, time, periods)}
			sum
		end

		def self.compare_EAR_EAY_series_payment(amt,rate,time,periods)
			calculate_EAY_series(amt, rate, time, periods) - calculate_EAR_series(amt, rate, time, periods)
		end

		def self.compare_EAR_Continuous_series_payment(amt,rate,time,periods)
			calculate_CC_series(amt, rate, time, periods) - calculate_EAR_series(amt, rate, time, periods)
		end

		def self.compare_EAY_Continuous_series_payment(amt,rate,time,periods)
			calculate_CC_series(amt, rate, time, periods) - calculate_EAY_series(amt, rate, time, periods)
		end

	end
end