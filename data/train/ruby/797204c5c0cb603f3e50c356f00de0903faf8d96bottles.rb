class DrinkingSong
  def song
    verses(99, 0)
  end

  def verses(high, low)
    high.downto(low).collect { |num| verse(num) }.join("\n")
  end

  def verse(num)
    chunk = chunk_for(num)
    chunk_successor = chunk_for(chunk.successor)
    "#{chunk} of beer on the wall, ".capitalize +
    "#{chunk} of beer.\n" + 
    "#{chunk.action}, " + 
    "#{chunk_successor} of beer on the wall.\n"
  end

  def chunk_for(num)
    case num
    when 0
      VerseChunkZero.new(num)
    when 1
      VerseChunkOne.new(num)
    when 6
      VerseChunkSix.new(num)
    else
      VerseChunk.new(num)
    end
  end
end

class VerseChunk
  attr_reader :number
  def initialize(number)
    @number = number
  end

  def container
    "bottles"
  end

  def pronoun
      "one"
  end

  def amount
    number.to_s
  end

  def action
      "Take #{pronoun} down and pass it around"
  end

  def successor
    number-1
  end

  def to_s
    "#{amount} #{container}"
  end

end

class VerseChunkZero < VerseChunk
  def amount
      "no more"
  end

  def action
      "Go to the store and buy some more"
  end

  def successor
      99
  end
end

class VerseChunkOne < VerseChunk
  def container
      "bottle"
  end

  def pronoun
      "it"
  end

end

class VerseChunkSix < VerseChunk
  def container
    "six-pack"
  end

  def amount
    1.to_s
  end

end
