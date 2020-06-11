class DiceSet
  attr_accessor :values
  attr_reader :roll_score
  attr_reader :non_scoring

  SCORE_THREE_ONES = 1000
  SCORE_THREE_FIVES = 500
  SCORE_THREE_OTHERS = 100
  SCORE_ONE = 100
  SCORE_FIVE = 50

  def roll(rolls)
    @values = Array.new    
    
    for i in 0...rolls
      @values[i]=1+rand(6)
    end
    calculate_score(rolls)
  end

  def calculate_score(rolls)
		@roll_score = 0
		@non_scoring = rolls
		
		count = calculate_frequency

		count.each_with_index do |frequency, counter|
			if counter == 1 
			  @roll_score = @roll_score + calculate_subscore(frequency, SCORE_THREE_ONES, SCORE_ONE)
			  @non_scoring -= frequency
			elsif counter == 5
			  @roll_score = @roll_score + calculate_subscore(frequency, SCORE_THREE_FIVES, SCORE_FIVE)
			  @non_scoring -= frequency
			elsif frequency >= 3
			  @roll_score = @roll_score + (counter * SCORE_THREE_OTHERS)
			  @non_scoring -=  3
			end
		end
  end

  def calculate_subscore(frequency, score_three, score_one)
  	return (score_three + (frequency - 3) * score_one) if frequency >= 3
  	return (score_one * frequency)
  end


  def calculate_frequency
  	count = [0,0,0,0,0,0,0]
		@values.each do |number|
			count[number]+=1
		end
		count
  end
  private :calculate_subscore, :calculate_frequency, :calculate_score

end