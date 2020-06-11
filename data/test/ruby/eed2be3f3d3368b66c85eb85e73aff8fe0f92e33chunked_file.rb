require 'forwardable'

module FBO
  class ChunkedFile < File
    extend Forwardable

    attr_reader     :file, :chunk_size
    def_delegators  :@file, :eof?, :eof


    DEFAULT_CHUNK_SIZE    = 250 * 1024   # 250KB


    def initialize(file, chunk_size = DEFAULT_CHUNK_SIZE)
      @file = file
      @chunk_size = chunk_size
    end

    def contents
      if @contents.nil?
        @contents = []
        while !eof
          @contents << next_chunk
        end
        @contents.compact!
      end
      @contents
    end


    private

    def next_chunk
      return nil if eof

      chunk, line = "", ""

      # Run up the chunk to about #chunk_size.
      begin
        line = gets
        break unless line
        chunk += line
      end while (chunk.bytesize < @chunk_size && !eof)

      # Add lines up to the end of a notice.
      if line && line !~ FBO::NOTICE_CLOSE_REGEXP
        begin
          line = gets
          break unless line
          chunk += line
          break if line =~ FBO::NOTICE_CLOSE_REGEXP
        end while (!eof)
      end

      return chunk.strip
    end
  end
end
