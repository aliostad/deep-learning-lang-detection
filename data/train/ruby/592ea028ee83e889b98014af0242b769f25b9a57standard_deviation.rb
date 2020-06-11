require 'pry'

class StandardDeviation

	attr_accessor :dataset, :mean, :variance_dataset, :variance, :variance_pop, :standard_deviation

	def initialize(dataset)
		@dataset = dataset #The inputed set of values
		@mean = 0
		@variance_dataset = []
		@variance = 0
		@variance_pop = 0
		@standard_deviation = 0
		calculate_mean
		calculate_variance_dataset #The calculated set of variance values based on dataset
		calculate_variance #For regular standard deviation
		calculate_variance_pop #For sample size standard deviation
	end

	#calculate the mean
	def calculate_mean
		total = 0
		@dataset.each do |i|
			total = total + i
		end
		@mean = total/@dataset.size.to_f
		return @mean 
	end

	#calculate the variance
	def calculate_variance_dataset
		@dataset.each do |i|
			@variance_dataset << (i-@mean)**2
		end
		return @variance_dataset 
	end

	#calculate the standard deviation
	def calculate_variance
		total = 0
		@variance_dataset.each do |i|
			total = total + i
		end
		@variance = total/variance_dataset.size.to_f
		return @variance 
	end

	#calcualte the standard deviation of sample population
	def calculate_variance_pop
		total = 0
		@variance_dataset.each do |i|
			total = total + i
		end
		@variance_pop = total/((variance_dataset.size.to_f)-1)
		return @variance_pop 
	end
	def calculate_standard_deviation(input)
		return Math.sqrt(input)
	end
end

binding.pry