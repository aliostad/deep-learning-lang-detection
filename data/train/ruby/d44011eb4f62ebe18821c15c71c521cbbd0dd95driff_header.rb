module Zappa
  class RiffHeader
    attr_reader :chunk_id, :format
    attr_accessor :chunk_size

    def initialize(file = nil)
      if file.nil?
        @chunk_id = 'RIFF'
        @chunk_size = 40
        @format = 'WAVE'
      else
        unpack(file)
      end
    end

    def pack
      @chunk_id + [@chunk_size].pack('V') + @format
    end

    def unpack(file)
      @chunk_id = file.read(4)
      @chunk_size = file.read(4).unpack('V').first
      @format = file.read(4)
      fail 'ID is not RIFF' unless @chunk_id == 'RIFF'
      fail 'Format is not WAVE' unless @format == 'WAVE'
    end
  end
end
