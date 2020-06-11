module Wolves
  class ChecksumError < RuntimeError; end
  class FormatError < RuntimeError; end

  # Payload chunk; the actual data hidden in a PNG file.
  # Since it's a part of a spanning archive, it needs an ID and the
  # total amount of chunks available in the archive.
  # This class makes sure the payload doesn't get damaged using a CRC.
  class Payload
    # 1337 4-byte header.
    HEADER = "w\0l\xf"
    
    # The number of the chunk in the sequence.
    attr_accessor :chunk_id
    # The total number of chunks in the sequence.
    attr_accessor :chunk_count
    # The raw data (for embedding in PNG files).
    attr_accessor :raw
    
    # Returns the decoded data from the raw data.
    def data
      raise RuntimeError, 'No raw data set' unless @raw

      header, @chunk_id, @chunk_count, crc32, b = Payload.decode(@raw).unpack('a4LLLa*')

      raise FormatError unless header == HEADER
      raise ChecksumError unless Zlib.crc32(b) == crc32

      b
    end

    def chunk_id
      raise RuntimeError, 'No raw data set' unless @raw

      unless @chunk_id
        header, @chunk_id, @chunk_count = Payload.decode(@raw).unpack('a4LL')
      end

      @chunk_id
    end

    def chunk_count
      raise RuntimeError, 'No raw data set' unless @raw

      unless @chunk_id
        header, @chunk_id, @chunk_count = Payload.decode(@raw).unpack('a4LL')
      end

      @chunk_count
    end

    # Accepts a chunk of the data you'd like to store.
    def data=(b)
      raise RuntimeError, 'No chunk data set' unless @chunk_id && @chunk_count

      @raw = Payload.encode([HEADER,
                             @chunk_id,
                             @chunk_count,
                             Zlib.crc32(b),
                             b
                            ].pack('a4LLLa*'))
    end

    #
    # TODO: Replace with base128 encoder. We can use ISO-8859, not
    # just ASCII.
    #
    class << self
      # Encode data to be compatible with the tEXt PNG encoding.
      def encode(b)
        Base64.encode64(b)
      end
      
      # Decode data encoded in PNG tEXt compatible encoding.
      def decode(b)
        Base64.decode64(b)
      end

      # Does this data seem like Payload data?
      def headercheck(raw)
        decode(raw)[0...Payload::HEADER.length] == Payload::HEADER
      end
    end
  end
end
