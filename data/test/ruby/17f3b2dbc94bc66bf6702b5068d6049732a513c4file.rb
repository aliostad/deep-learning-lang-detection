require 'digest/md5'

module WOW::BLTE
  class File
    attr_reader :header, :size

    def self.open(path, mode)
      file = ::File.open(path, mode)
      self.new(file)
    end

    def self.valid?(path)
      file = ::File.open(path, 'rb')

      begin
        self.new(file, decode: false)
      rescue WOW::BLTE::Error => e
        file.close if !file.closed?
        return false
      end

      true
    end

    def initialize(stream_or_data, opts = {})
      auto_decode = opts[:decode] != false

      blte_stream = WOW::Stream.new(stream_or_data)

      @header = read_header(blte_stream)
      data_chunks = read_chunks(blte_stream)

      blte_stream.close

      if auto_decode
        decode(data_chunks)
      else
        @stream = nil
      end
    end

    def method_missing(method, *arguments, &block)
      @stream.send(method, *arguments, &block)
    end

    private def decode(data_chunks)
      @stream = WOW::Stream.new

      data_chunks.each do |data_chunk|
        @stream.write(data_chunk.decode)
      end

      @size = @stream.size

      # If chunk info header was present, verify the size
      if !@header.chunk_info.nil? && @size != @header.chunk_info.decoded_size
        raise Errors::InvalidDecodedSize.new(@header.chunk_info.decoded_size, @size)
      end

      @stream.pos = 0
    end

    private def read_header(stream)
      header = Header.new

      header.signature = stream.read_char(4)
      header.size = stream.read_uint32be

      if header.size > 0
        chunk_info = ChunkInfo.new

        chunk_info.flags = stream.read_uint8
        chunk_info.chunk_count = stream.read_uint24be
        chunk_info.decoded_size = 0

        chunk_info.chunk_count.times do
          entry = ChunkInfoEntry.new

          entry.encoded_size = stream.read_uint32be
          entry.decoded_size = stream.read_uint32be
          entry.encoded_checksum = stream.read_char(16)

          chunk_info.entries << entry

          chunk_info.decoded_size += entry.decoded_size
        end

        header.chunk_info = chunk_info
      end

      header
    end

    private def read_chunks(stream)
      chunks = []

      # Single chunk files do not have chunk info in the header
      if @header.chunk_info.nil?
        encoded_data = stream.read

        chunks << Chunk.new(encoded_data)
      else
        @header.chunk_info.entries.each do |chunk_info|
          encoded_data = stream.read_bytes(chunk_info.encoded_size)
          encoded_checksum = Digest::MD5.digest(encoded_data)

          if encoded_checksum != chunk_info.encoded_checksum
            raise Errors::InvalidChecksum.new(chunk_info.encoded_checksum, encoded_checksum)
          end

          chunks << Chunk.new(encoded_data)
        end
      end

      chunks
    end
  end
end
