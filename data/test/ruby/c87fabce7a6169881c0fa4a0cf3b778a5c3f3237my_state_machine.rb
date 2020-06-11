class MyStateMachine
  def process obj
    process_hook obj
  end

private
  def process_state_1 obj
    puts 'process_state_1 get invoked'
    # ...
    class << self
      alias process_hook process_state_2
    end
  end

  def process_state_2 obj
    puts 'process_state_2 get invoked'
    # ...
    class << self
      alias process_hook process_state_1
    end
  end

  # Set up initial state
  alias process_hook process_state_1
end

sm = MyStateMachine.new
sm.process Object.new
sm.process Object.new
sm.process Object.new
sm.process Object.new
