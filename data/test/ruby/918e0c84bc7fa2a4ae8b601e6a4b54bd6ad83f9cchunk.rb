module MonospaceTextFormatter
  class Chunk

    def initialize(string=nil)
      @remaining_string = ""
        @atomic_chunks = []
        @display_length = 0

      concat(string) unless string.nil?
    end

    def duplicate
      duplicate = self.clone
      duplicate.instance_variable_set("@remaining_string", @remaining_string.clone)
      duplicate.instance_variable_set(   "@atomic_chunks",    @atomic_chunks.clone)
      duplicate
    end

    def multiline?
      atomic_chunks.any? { |atomic_chunk| atomic_chunk.newline? } or remaining_string.include?("\n")
    end

    def blank?
      to_s.strip.empty?
    end

    def empty?
      to_s.empty?
    end

    def display_length
      slice_whole_remaining_string unless remaining_string.empty?
      @display_length
    end

    def non_display_length
      slice_whole_remaining_string unless remaining_string.empty?
      to_s.length - display_length
    end

    def concat(string_or_chunk)

      if string_or_chunk.kind_of?(Chunk)
        slice_whole_remaining_string if string_or_chunk.atomic_chunks.any?

        string_or_chunk.atomic_chunks.each { |atomic_chunk| push_atomic_chunk(atomic_chunk) }
        remaining_string.concat(string_or_chunk.remaining_string)

      else
        remaining_string.concat(string_or_chunk)

      end
      self
    end

    def +(string_or_chunk)
      duplicate.concat(string_or_chunk)
    end

    def slice!(max_display_length=nil, smartly_split_too_long_words=true)
      sliced_chunk = self.class.new
      return sliced_chunk if max_display_length == 0

      while retrieve_first_atomic_chunk

        if atomic_chunks.first.blank? and sliced_chunk.blank?
          shift_atomic_chunk
          next

        elsif max_display_length && (atomic_chunks.first.display_length + sliced_chunk.display_length > max_display_length)
          break

        elsif atomic_chunks.first.newline?
          shift_atomic_chunk
          break

        else
          sliced_chunk.push_atomic_chunk(shift_atomic_chunk)
        end
      end

      sliced_chunk.pop_atomic_chunk while sliced_chunk.atomic_chunks.last && sliced_chunk.atomic_chunks.last.blank?

      if smartly_split_too_long_words &&
        max_display_length &&
        retrieve_first_atomic_chunk &&
        atomic_chunks.first.display_length > max_display_length

        smartly_split_too_long_word(max_display_length, sliced_chunk)
      end

      sliced_chunk
    end

    def slice(max_display_length)
      duplicate.slice!(max_display_length)
    end

    def to_s
      atomic_chunks.map { |atomic_chunk| atomic_chunk.to_s }.join + remaining_string
    end

    def inspect
      %Q(#<#{self.class} #{to_s.inspect}>)
    end

    def ==(other)
      to_s == other.to_s
    end

    protected

    def atomic_chunk_factory
      @atomic_chunk_factory ||= AtomicChunkFactory.new
    end

    attr_accessor :atomic_chunks, :remaining_string

    def push_atomic_chunk(atomic_chunk)
      atomic_chunks.push(atomic_chunk)
      @display_length += atomic_chunk.display_length
    end

    def pop_atomic_chunk
      atomic_chunk = atomic_chunks.pop
      @display_length -= atomic_chunk.display_length
      atomic_chunk
    end

    def unshift_atomic_chunk(atomic_chunk)
      atomic_chunks.unshift(atomic_chunk)
      @display_length += atomic_chunk.display_length
    end

    def shift_atomic_chunk
      atomic_chunk = atomic_chunks.shift
      @display_length -= atomic_chunk.display_length
      atomic_chunk
    end

    def delete_atomic_chunk_at(index)
      atomic_chunk = atomic_chunks.delete_at(index)
      @display_length -= atomic_chunk.display_length
      atomic_chunk
    end

    def retrieve_first_atomic_chunk
      !!(atomic_chunks.first or slice_atomic_chunk_from_remaining_string!)
    end

    def slice_whole_remaining_string
      slice_atomic_chunk_from_remaining_string! until remaining_string.empty?
    end

    def slice_atomic_chunk_from_remaining_string!
      if atomic_chunk = slice_from_remaining_string!
        push_atomic_chunk(atomic_chunk)
        atomic_chunk
      end
    end

    def slice_from_remaining_string!
      atomic_chunk_factory.slice_from!(remaining_string)
    end

    def smartly_split_too_long_word(max_display_length, sliced_chunk)
      length_needed = max_display_length - sliced_chunk.display_length - (sliced_chunk.blank? ? 0 : 1)
      return unless atomic_chunks.first.display_length % max_display_length <= length_needed

      atomic_chunk = shift_atomic_chunk
      atomic_chunk_1, atomic_chunk_2 = atomic_chunk_factory.split_string(atomic_chunk.to_s, length_needed)

      sliced_chunk.concat(" ") unless sliced_chunk.blank?
      sliced_chunk.concat(atomic_chunk_1.to_s)

      unshift_atomic_chunk(atomic_chunk_2)
    end
  end
end
