require "arpad/version"

module Arpad
  class Calculator
    def self.calculate_elo(elo_one, elo_two, outcome, config = {})
      k_factor = config[:k_factor] || 16
      transformed_rating_one = calculate_transformed_rating(elo_one)
      transformed_rating_two = calculate_transformed_rating(elo_two)
      expected_score = calculate_expected_score(
        transformed_rating_one,
        transformed_rating_two
      )
      score_value = calculate_score_value(outcome)

      (elo_one.to_i + (k_factor * (score_value - expected_score))).to_i
    end

    private

    def self.calculate_transformed_rating(elo)
      (10**(elo.to_f / 400))
    end

    def self.calculate_expected_score(t_rating_one, t_rating_two)
      t_rating_one / (t_rating_one + t_rating_two)
    end

    def self.calculate_score_value(outcome)
      if outcome.to_s == "win"
        1
      elsif outcome.to_s == "lose"
        0
      elsif outcome.to_s == "tie"
        0.5
      else
        raise "user inputted #{outcome} which is not a valid outcome"
      end
    end
  end
end
