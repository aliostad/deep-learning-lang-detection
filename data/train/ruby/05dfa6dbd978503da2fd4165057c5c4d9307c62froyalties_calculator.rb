class OfcpScoring::RoyaltiesCalculator
  MIDDLE = {
    "StraightFlush" => 20, "FourOfAKind" => 16, "FullHouse" => 12,
    "Flush" => 8, "Straight" => 4, "Pair" => 0, "HighCard" => 0
  }

  BACK = {
    "RoyalFlush" => 20, "StraightFlush" => 10, "FourOfAKind" => 8,
    "FullHouse" => 6, "Flush" => 4, "Straight" => 2, "Pair" => 0,
    "HighCard" => 0
  }

  def calculate_bonus(hand, position)
    return calculate_front(hand) if position == :front
    return calculate_middle(hand) if position == :middle
    return calculate_back(hand) if position == :back
  end

private
  def calculate_back(hand)
    BACK[hand.rank_name]
  end

  def calculate_middle(hand)
    MIDDLE[hand.rank_name]
  end

  def calculate_front(hand)
    return 0 unless hand.rank_name == "Pair"
    bonus_accumulator = 0
    bonus_start = 5
    while hand.ranks.max > bonus_start
      bonus_accumulator += 1
      bonus_start += 1
    end
    bonus_accumulator
  end
end
