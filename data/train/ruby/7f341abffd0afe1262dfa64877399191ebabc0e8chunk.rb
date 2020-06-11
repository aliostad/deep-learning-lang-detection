module MonospaceTagTextFormatter
  class Chunk < MonospaceTextFormatter::Chunk

    def slice!(max_display_length=nil, smartly_split_too_long_word=true)
      sliced_chunk = super

      sliced_chunk.unclosed_tags_data.reverse.each do |data|
        sliced_chunk.push_atomic_chunk(AtomicChunk.closing_tag(data[:name]))
        unshift_atomic_chunk(data[:chunk])
      end

      sliced_chunk
    end

    protected

    def atomic_chunk_factory
      @atomic_chunk_factory ||= AtomicChunkFactory.new
    end

    def unclosed_tags_data
      opened_tags_data = []

      atomic_chunks.each do |atomic_chunk|

        if atomic_chunk.opening_tag?
          opened_tags_data.push(:name => atomic_chunk.tag_name, :chunk => atomic_chunk)

        elsif atomic_chunk.closing_tag? && opened_tags_data.last && atomic_chunk.tag_name == opened_tags_data.last[:name]
          opened_tags_data.pop

        end
      end

      opened_tags_data
    end
  end
end
