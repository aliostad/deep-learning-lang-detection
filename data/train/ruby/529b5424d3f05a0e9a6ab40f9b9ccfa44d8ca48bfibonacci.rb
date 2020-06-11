class Fibonacci
  # Implement a method that will calculate the Nth number of the Fibonacci
  # sequence (http://en.wikipedia.org/wiki/Fibonacci_number)
  # tested with
  # bundle exec rspec spec/fibonacci_spec.rb
  # passed 

  def self.calculate(n)
    # one-line recursive fibonacci calculation found here: 
    # http://stackoverflow.com/questions/12178642/fibonacci-sequence-in-ruby-recursion 
    # edited Mar 13 '13 at 20:10 answered Aug 29 '12 at 13:07 by PriteshJ
        n <= 1 ? n :  calculate( n - 1 ) + calculate( n - 2 ) 
  end

end