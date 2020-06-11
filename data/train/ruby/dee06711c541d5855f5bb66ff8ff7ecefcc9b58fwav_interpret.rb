class Wav
  attr_accessor :wav, :file, :sample_rate, :format_chunk, 
                :riff_chunk, :data_chunk
  
  SAMPLE_RATE = 44100

  def initialize(filename)
    @sample_rate = SAMPLE_RATE
    @file = File.open(filename, "wb")

    @riff_chunk = RiffChunk.new
    @riff_chunk.chunk_id = "RIFF".unpack("N").first
    @riff_chunk.format = "WAVE".unpack("N").first

    @format_chunk = FormatChunk.new
    # Be careful!! Need the single spacing directive for chunk_id!!
    @format_chunk.chunk_id = "fmt ".unpack("N").first
    @format_chunk.chunk_size = 16
    @format_chunk.audio_format = 1
    @format_chunk.num_channels = 2
    @format_chunk.bits_per_sample = 16
    @format_chunk.sample_rate = @sample_rate
    @format_chunk.byte_rate = @format_chunk.sample_rate *
                              @format_chunk.num_channels *
                              @format_chunk.bits_per_sample/2
    @format_chunk.block_align = @format_chunk.num_channels *
                                @format_chunk.bits_per_sample/2
    @data_chunk = DataChunk.new
    @data_chunk.chunk_id = "data".unpack("N").first
  end

  def write(stream_data)
    stream_data.each_with_index do |s,i|
      @data_chunk.stream[i].left = s[0]
      @data_chunk.stream[i].right = s[1]
    end
    @data_chunk.chunk_size = stream_data.length *
                             @format_chunk.num_channels *
                             @format_chunk.bits_per_sample/8
    @riff_chunk.chunk_size = 36 + @data_chunk.chunk_size
    @wav = WavFormat.new
    @wav.riff_chunk = @riff_chunk
    @wav.format_chunk = @format_chunk
    @wav.data_chunk = @data_chunk
    @wav.write(@file)
  end

  def close
    @file.close
  end
end
