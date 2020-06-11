module MonospaceTextFormatter
  class AtomicChunkFactory

    REGEXP = /^(?:\n|[ \t]+|[^ \t\n]+)/

    def new(string)
      AtomicChunk.new(string)
    end

    def slice_from!(string)
      (slice = string.slice!(regexp)) ? new(slice) : nil
    end

    def slice_from(string)
      slice_from!(string.dup)
    end

    def split_string(string, length)
      duplicated_string = string.dup
      head_chunk = new(duplicated_string.slice!(0, length))
      tail_chunk = new(duplicated_string)
      [ head_chunk, tail_chunk ]
    end

    protected

    def regexp
      REGEXP
    end
  end
end
