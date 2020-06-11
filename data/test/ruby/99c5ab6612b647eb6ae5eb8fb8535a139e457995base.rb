class Handler
  attr_accessor :next_handler
  def initialize next_handler = nil
    @next_handler = next_handler
  end

  def handle number
    if @next_handler
      @next_handler.handle number
    else
      p 'error'
    end
  end
end

class Handler_2 < Handler
  def handle number
    if number % 2 == 0
      p "#{number} processed by #{self.class.to_s}"
    else
      super number
    end
  end
end

class Handler_3 < Handler
  def handle number
    if number % 3 == 0
      p "#{number} processed by #{self.class.to_s}"
    else
      super number
    end
  end
end

class Handler_4 < Handler
  def handle number
    if number % 4 == 0
      p "#{number} processed by #{self.class.to_s}"
    else
      super number
    end
  end
end

objects = 1..10

chain = Handler_4.new Handler_3.new Handler_2.new

objects.each do |object|
  chain.handle object
end