class Array
  # Splits the array into number_of_chunks so that each chunk is 
  # between 0.5-1.5 of the "ideal" chunk size (ideal size = array.length / number_of_chunks)
  def split_random(number_of_chunks)
    def take_drop(n)
      [take(n), drop(n)]
    end
    
    def split_random_acc(ideal_chunk_size, number_of_chunks, l, acc)
      if (number_of_chunks == 1)
        if acc.empty?
          return [l]
        else
          return(acc + [l])
        end
      else
        half_ideal = ideal_chunk_size/2
        chunk_size = rand(half_ideal..(ideal_chunk_size + half_ideal))
        head, tail = l.take_drop(chunk_size)
        return (acc + [head]) if tail == []
        split_random_acc(ideal_chunk_size, number_of_chunks-1, tail, acc + [head])
      end
    end
    
    ideal_chunk_size = (size.to_f / number_of_chunks).round
    split_random_acc(ideal_chunk_size, number_of_chunks, self, [])
  end
end