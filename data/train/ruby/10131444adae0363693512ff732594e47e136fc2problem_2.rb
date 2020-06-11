class Problem2
  def calculate(problem_array=[1,2], upper_limit)
    result_array = problem_array
    temp = 0

    while temp < upper_limit
      temp = sum_calculate_array(result_array)
      result_array << temp if temp < upper_limit
    end

    return result_array
  end

  def sum_calculate_array(problem_array)
    problem_array[-1] + problem_array[-2]
  end

  def pick_even_values(result_array)
    result_array.select { |i| i.even? }
  end

  def sum_even_fibonacci(upper_limit)
    fibonacci_numbers = calculate([1,2], upper_limit)
    even_fibonacci_sum = pick_even_values(fibonacci_numbers).inject(:+)

  end
end



