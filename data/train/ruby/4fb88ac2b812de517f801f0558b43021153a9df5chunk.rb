class FormAiffChunk
  attr_accessor(:id, :size, :form_type, :common, :sound)

  def initialize(file)
    @id= file.read(4)
    @size = file.read(4).unpack('N')[0].to_i
    @form_type = file.read(4)
    @common = file.read(26)
    @sound = file.read(@size - 26)
  end

  def to_s
    <<EOS
FormAiffChunkID: #{@id}
Size:            #{@size}
FormType:        #{@form_type}
EOS
  end
end

class CommonChunk
  attr_accessor(:id, :common_size, :num_channels, :num_sample_frames, :sample_size, :sample_rate)

  def initialize(chunk)
    @id = chunk.common.slice(0,4)
    @common_size = chunk.common.slice(4,4).unpack('N')[0].to_i
    @num_channels = chunk.common.slice(8,2).unpack('n')[0].to_i
    @num_sample_frames = chunk.common.slice(10,4).unpack('N')[0].to_i
    @sample_size = chunk.common.slice(14,2).unpack('n')[0].to_i 
    @sample_rate = chunk.common.slice(18,8).unpack('n')[0].to_i
  end

  def to_s
    <<EOS
CommonChunkID:   #{@id}
Channels:        #{@num_channels}
NumSampleFrames: #{@num_sample_frames}
SampleSize:      #{@sample_size}
SampleRate:      #{@sample_rate}[Hz]
EOS
  end
end

class SoundDataChunk
  attr_accessor(:id, :size, :offset, :block_size, :data)

  def initialize(chunk)
    @id = chunk.sound.slice(0,4)
    @size = chunk.sound.slice(4,4).unpack('N')[0].to_i
    @offset = chunk.sound.slice(8,4).unpack('n')[0].to_i
    @block_size = chunk.sound.slice(12,4).unpack('n')[0].to_i
    @data = chunk.sound.slice(16,@size)
  end

  def to_s
    <<EOS
SoundDataChunkID: #{@id}
Size:             #{@size}
Offset:           #{@offset}
BlockSize:        #{@block_size}
EOS
  end
end
