class Job
  @queue = 'math_workers'

  class << self
    def perform(work_to_do, limit)
      case work_to_do
      when 'calculate_error'
        sleep 5
        raise ProcessingError.new("I coudn't finish my job! Damn!")
      when 'calculate_fibonacci'
        calculate_fibonacci(limit)
      end
    end

    private
    def calculate_fibonacci(limit)
      numbers = [0, 1]
      limit.times do
        numbers.push(numbers[-1] + numbers[-2])
        sleep 2
      end
      puts numbers.last
    end
  end
end

class ProcessingError < StandardError; end