module NumberToWordsRole

  def number_valid?(index)
    index >= 0 && index < length() ** 3
  end

  # (int) -> int
  def index_to_chunk_index(index: index)
    nb_combinations = length() ** ::TUPLE_SIZE
    nb_chunk = nb_combinations / ::CHUNK_SIZE

    index_in_chunk = index / ::CHUNK_SIZE
    element_in_chunk = index.modulo(::CHUNK_SIZE)
    chunk = element_in_chunk * nb_chunk
    chunk + index_in_chunk
  end

  # (int) -> [string]
  def chunk_index_to_words(chunk_index: chunk_index)
    nb_combinations_max = length() ** ::TUPLE_SIZE
    if chunk_index >= nb_combinations_max
      :index_too_high
    else
      indexes = find_indexes(chunk_index)
      indexes.map { |index| find_word(chunk_index) }
    end
  end

  # (int) -> [int]
  def find_indexes(remainder, which_tuple = 0)
    if which_tuple < ::TUPLE_SIZE
      cur_tuple_power = ::TUPLE_SIZE - which_tuple - 1
      res = remainder / (length() ** cur_tuple_power)
      remainder = remainder - res * (length() ** cur_tuple_power)
      [res] + find_indexes(remainder, which_tuple + 1)
    else
      []
    end
  end

  def find_word(index)
    self[index]
  end
end
