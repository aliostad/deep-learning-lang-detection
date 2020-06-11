module Variance
  class ComputedStandardDeviation < Array
    def initialize(number_array)
      puts '*'*80
      puts 'Computed Standard Deviation Called'
      puts '*'*80

      num_arr = number_array
      total = num_arr.count
      if total && total > 0
        calculate_variance = variance(total, num_arr)
        calculate_s_deviation = Math.sqrt(calculate_variance) if calculate_variance
        self << calculate_s_deviation
      end
    end

    protected

    def variance(total, num_arr)
      sorted_array = num_arr
      sqr_of_each_var = sorted_array.map {|num| num ** 2}
      sum_of_sqr_array = sqr_of_each_var.inject{|sum,x| sum+x}
      ans = (sum_of_sqr_array>0 && total>0) ? (sum_of_sqr_array.to_f/total.to_f) : 0
    end
  end
end