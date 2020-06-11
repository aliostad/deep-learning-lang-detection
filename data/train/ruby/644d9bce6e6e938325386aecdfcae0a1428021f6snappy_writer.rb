require 'snappy'
require 'odps_protobuf'

module Aliyun
  class SnappyWriter
    CHUNK_MAX = 65_536
    COMPRESSION_THRESHOLD = 0.125
    COMPRESSED_CHUNK = 0x00
    UNCOMPRESSED_CHUNK = 0x01
    STREAM_IDENTIFIER = 'sNaPpY'
    IDENTIFIER_CHUNK = 0xff

    def self.compress(data)
      load_snappy

      out = [[IDENTIFIER_CHUNK + (STREAM_IDENTIFIER.length << 8)].pack('<L'), STREAM_IDENTIFIER.force_encoding('ASCII-8BIT')]
      (0..data.length).step(CHUNK_MAX) do |i|
        chunk = data[i, CHUNK_MAX]
        crc = masked_crc32c(chunk)
        compressed_chunk = Snappy.deflate(chunk)
        if compressed_chunk.length <= (1 - COMPRESSION_THRESHOLD) * chunk.length
          chunk = compressed_chunk
          chunk_type = COMPRESSED_CHUNK
        else
          chunk_type = UNCOMPRESSED_CHUNK
        end
        chunk.force_encoding('ASCII-8BIT')
        out << [chunk_type + ((chunk.length + 4) << 8), crc].pack('<LL')
        out << chunk
      end
      out.join('')
    end

    def self.masked_crc32c(data)
      crc = OdpsProtobuf::CrcCalculator.calculate(StringIO.new(data))
      (((crc >> 15) | (crc << 17)) + 0xa282ead8) & 0xffffffff
    end

    def self.load_snappy
      require 'snappy'
    rescue LoadError
      raise 'Install snappy to support x-snappy-framed encoding: https://github.com/miyucy/snappy'
    end
  end
end
