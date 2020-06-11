module RubyQuiz
  class BannedWords
    attr_reader :filter, :dictionary, :banned_words

    def initialize( dict, filt )
      @filter = filt
      @banned_words =Array.new()
      find_banned(dict)
    end

    def find_banned(array_of_words)
        chunks = chunk_array(array_of_words)
        chunks.each { |chunk|
            if !(filter.clean?(chunk.join(" "))) then
                if(chunk.length == 1) then
                    @banned_words.push(chunk[0])
                else
                    find_banned(chunk)
                end
            end
        }
    end

    def chunk_array(array, pieces=3)
      len = array.length;
      mid = (len/pieces)
      chunks = []
      start = 0
      1.upto(pieces) do |i|
        last = start+mid
        last = last-1 unless len%pieces >= i
        chunks << array[start..last] || []
        start = last+1
      end
      chunks
    end
  end
end
