class Jiffy
  class ArrayMimickingIO
    CHUNK_SIZE = 1_000_000 # 1 MB

    attr_accessor :io, :chunk, :bytes_read

    def initialize(io)
      @io = io
      @chunk = []
      @bytes_read = 0
    end

    def [](nth_byte)
      read_chunk unless has_nth_byte?(nth_byte)

      fetch_nth_byte(nth_byte)
    end

    private

    def fetch_nth_byte(nth_byte)
      index = nth_byte - bytes_read + chunk.length

      chunk[index]
    end

    def has_nth_byte?(nth_byte)
      bytes_read > nth_byte
    end

    def read_chunk
      @chunk = @io.readpartial(CHUNK_SIZE).each_codepoint.to_a

      @bytes_read += @chunk.length
    end
  end
end
