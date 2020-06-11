require File.expand_path(File.dirname(__FILE__) + "/../lib/number_definitions")

class OCR
  
  @@possibleNumbers = {  NumberDefinitions::Zero  => 0,
                         NumberDefinitions::One   => 1,
                         NumberDefinitions::Two   => 2,
                         NumberDefinitions::Three => 3,
                         NumberDefinitions::Four  => 4,
                         NumberDefinitions::Five  => 5,
                         NumberDefinitions::Six   => 6,
                         NumberDefinitions::Seven => 7,
                         NumberDefinitions::Eight => 8,
                         NumberDefinitions::Nine   => 9
                       }
  attr_reader :number
                       
  def initialize
    
  end
  
  def parse(chunk)
    result = @@possibleNumbers[chunk]
    if result.nil? then
      "?"
    else
      result
    end
  end
  
  def parseAll(bigChunk)
    result = []
    currPos = 0
    9.times{
       chunk = []
       chunk << bigChunk[0][currPos..currPos + 2]
       chunk << bigChunk[1][currPos..currPos + 2]
       chunk << bigChunk[2][currPos..currPos + 2]
       printNicely(chunk)
       result << parse(chunk)
       currPos = currPos + 3
    }
    result
  end

  def printNicely(chunk)
    chunk.each{ |line| puts "\"#{line}\""}
  end
  
end