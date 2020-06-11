module Nebulous
  module Input
    module Parsing
      def parse_row
        sequence
        Row.parse(read_complete_line, options).to_numeric.merge(@headers)
      end

      def raw_headers
        ln = read_complete_line
        Row.parse(ln, options)
      end

      def read_headers
        @headers ||= Row.headers(read_complete_line, options)
      end

      def chunk
        @chunk ||= Chunk.new chunk_options
      end

      def sequence
        @index += 1
      end

      def limit?
        options.limit && options.limit == @index
      end

      def yield_chunk(chunk, &_block)
        if chunk.full? || file.eof?
          yield chunk
          @chunk = nil
        end
      end

      def iterate(&block)
        while !file.eof?
          break if limit?
          chunk << replace_keys(parse_row)
          yield_chunk(chunk, &block) if block_given? && options.chunk
        end

        @chunk.to_a
      end

      def replace_keys(row)
        return row unless options.mapping
        row.map do |key, value|
          [options.mapping[key], value] if options.mapping.has_key?(key)
        end.compact.to_h
      end

      def chunk_options
        Hash.new.tap do |attrs|
          attrs[:size] = options.chunk.to_i if options.chunk
        end
      end
    end
  end
end
