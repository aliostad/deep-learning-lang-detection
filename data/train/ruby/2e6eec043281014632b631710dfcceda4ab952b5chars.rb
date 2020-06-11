require 'markov/base'

module Markov
  class Chars < Base
    # Given a chunk of characters and a length,
    # add to our sequence counts all information
    # you can glean from it.
    #
    # For example:
    #
    # chunk size: 3
    # sample text: 'tasty'
    # 'tas' is followed by 't'
    # 'ast' is followed by 'y'
    def populate_input_sequences(chunk_size = 4)
      input.gsub(/[\n]+/, ' ').chars.each_cons(chunk_size + 1) do |chunk|

        # Make a string from the array of characters
        chunk = chunk.join('')

        following_char = chunk.slice!(-1)

        # Note that we've seen this following char 1 (more) time
        input_sequences[chunk][following_char] += 1
      end

      true
    end

    def separator
      ''
    end

  end
end
