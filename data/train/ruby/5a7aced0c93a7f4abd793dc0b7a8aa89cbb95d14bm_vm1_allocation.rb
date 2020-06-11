@retained = []

MAX_STRING_SIZE = 100
Random.srand(1234)

def stress(allocate_count, retain_count, chunk_size)
  chunk = []

  while retain_count > 0 || allocate_count > 0
    if retain_count == 0 || (Random.rand < 0.5 && allocate_count > 0)
      chunk << " " * (Random.rand * MAX_STRING_SIZE).to_i
      allocate_count -= 1

      if chunk.length > chunk_size
        chunk = []
      end
    else
      @retained << " " * (Random.rand * MAX_STRING_SIZE).to_i
      retain_count -= 1
    end
  end
end

stress(1_000_000, 600_000, 200_000)
