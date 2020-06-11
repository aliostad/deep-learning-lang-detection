
require 'enumerator'

class Array
  
  ##
  # Return array of elements after +position+.

  def from position
    self[position..-1]
  end

  ##
  # Return array of elements up to +position+.
  
  def to position
    self[0..position]
  end
  
  ##
  # Pad array with expected length +n+, and +pad_with+ an
  # optional object or nil.
  #
  # === Examples
  #
  #   [1,2].pad(4)  # => [1,2,nil,nil]
  #   [1,2].pad(4)  # => [1,2,'x','x']
  #   [1,2].pad(2)  # => [1,2]
  #
  
  def pad n, pad_with = nil
    fill pad_with, length, n - length
  end
  
  ##
  # Split an array into chunks of length +n+. Optionally you
  # may +pad_with+ an object to retain a uniform length per chunk.
  #
  # === Examples
  #
  #   [1,2,3].chunk(2)         # => [[1,2], [3, nil]]
  #   [1,2,3].chunk(2, 'x')    # => [[1,2], [3, 'x']]
  #   [1,2,3].chunk(2, false)  # => [[1,2], [3]]
  #   [1,2,3].in_groups_of(2) do |chunk|
  #     # Do something
  #   end
  #
  # === See
  #
  # * Array#pad
  #
  
  def chunk n, pad_with = nil, &block
    returning [] do |chunks|
      each_slice n do |chunk|
        chunk.pad n, pad_with unless pad_with == false
        yield chunk if block
        chunks << chunk
      end
    end
  end
  alias :in_groups_of :chunk
  
end