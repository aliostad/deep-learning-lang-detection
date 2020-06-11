class FibonacciDynamic
  def initialize
    @result   = 0
    @current_num = 1 
    @prev_num = 0
  end

  def fib(position)
    enum = (position+1).times.map
    calculate_each(enum) { calculate }
  end

  def calculate_each(enum)
    while true
      begin
        enum.next
      rescue StopIteration
        return $!.result.last
      end
      fibonacci_value = yield 
      enum.feed fibonacci_value
    end
  end

  private
    def calculate
      def calculate
        def calculate
          (@prev_num, @current_num = @current_num, @prev_num + @current_num).last
        end
        @current_num = 1 
      end  
      @prev_num = 0
    end
end
