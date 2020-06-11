require 'minitest/autorun'
require_relative '../lib/sequence_comparison'

class SequenceComparisonTest < Minitest::Test
  def test_that_it_calculates_correct_elements
    assert_equal 3, calculate_correct_elements(%w[r b b y], %w[r g b y])
    assert_equal 0, calculate_correct_elements(%w[g g b b], %w[r r y y])
    assert_equal 4, calculate_correct_elements(%w[y b g r], %w[r g b y])
  end

  def test_that_it_calculates_correct_positions
    assert_equal 2, calculate_correct_positions(%w[r y b b], %w[r g b y])
    assert_equal 0, calculate_correct_positions(%w[y b g r], %w[r g b y])
    assert_equal 4, calculate_correct_positions(%w[r g b y], %w[r g b y])
  end

  def test_that_it_calculates_correct_guess
    assert SequenceComparison.new(%w[r g b y], %w[r g b y]).correct_guess?
    assert !SequenceComparison.new(%w[b b b b], %w[r g b y]).correct_guess?
  end

private
  def calculate_correct_elements(guess, answer)
    SequenceComparison.new(guess, answer).num_of_correct_elements
  end

  def calculate_correct_positions(guess, answer)
    SequenceComparison.new(guess, answer).num_of_correct_positions
  end
end
