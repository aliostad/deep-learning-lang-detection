module ProjectInstances::Rates

  def calculate_attitudinal_rates
    calculate_attitudinal_assessment
    self.plausible_attitude_index = calculate_attitudinal_index(1)
    self.naive_attitude_index = calculate_attitudinal_index(0)
    self.adecuate_attitude_index = calculate_attitudinal_index(2)
  end

  def calculate_attitudinal_assessment
    self.question_instances.each do |qi|
      qi.answer_instances.each do |ai|
        ai.calculate_attitudinal_assessment
      end
    end
  end

  def calculate_attitudinal_index(category)
    total = 0
    index = 0
    self.question_instances.each do |qi|
      qi.answer_instances.each do |ai|
        if ai.answer_category == category && ai.attitudinal_assessment
          index+= ai.attitudinal_assessment
          total+= 1
        end
      end
    end
    if total == 0
      0
    else
      index/total
    end
  end

  def attitudinal_global_index
    (self.plausible_attitude_index.to_f + self.naive_attitude_index.to_f + self.adecuate_attitude_index.to_f) / 3
  end

  def standard_deviation(average)
    summation = 0
    n = 0
    self.question_instances.each do |question|
      question.answer_instances.each do |answer|
        if attitudinal_assessment = answer.calculate_attitudinal_assessment
          summation += (attitudinal_assessment - average) ** 2
          n += 1
        end
      end
    end

    if n > 1
      Math.sqrt(summation.abs / (n - 1))
    else
      0
    end
  end
end
