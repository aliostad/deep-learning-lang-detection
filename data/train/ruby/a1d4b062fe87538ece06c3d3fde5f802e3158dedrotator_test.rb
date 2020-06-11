require "minitest/spec"
require "minitest/autorun"
require_relative "../lib/rotator"
require_relative "../lib/char_set"

describe Rotator do
  it "uses a charset to get alphabet info" do
    r = Rotator.new(chunk("a"), nil, CharSet.new(:reverse))
    assert_equal CharSet::ALPHABETS[:reverse], r.char_set.alphabet
  end

  it "uses forward charset by default" do
    r = Rotator.new(chunk("a"), nil)
    assert_equal CharSet::ALPHABETS[:forward], r.char_set.alphabet
  end

  it "finds indices of chars" do
    assert_equal chunk(0), Rotator.new(chunk("a"), nil).char_indices
  end

  it "rotates large offsets back to beginning of alphabet" do
    assert_equal chunk(1), Rotator.new(chunk("."), chunk(3)).rotated_indices
  end

  it "rotates 4 chars using provided offsets" do
    offsets = chunk(1)
    input = chunk("a")
    assert_equal chunk("b"), Rotator.new(input, offsets).rotated_chars
  end

  it "rotates characters around end of alphabet" do
    offsets = chunk(11)
    input = chunk("6")
    assert_equal chunk("e"), Rotator.new(input, offsets).rotated_chars

  end

  it "reverses characters using provided offsets" do
    offsets = chunk(1)
    input = chunk("b")
    assert_equal chunk("a"), Rotator.new(input, offsets, CharSet.new(:reverse)).rotated_chars
  end

  it "reverses characters around end of alphabet" do
    offsets = chunk(11)
    input = chunk("e")
    assert_equal chunk("6"), Rotator.new(input, offsets, CharSet.new(:reverse)).rotated_chars
  end
end

def chunk(value, size = 4)
  Array.new(size) { value }
end
