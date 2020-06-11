require 'bindata'

class RiffChunk < BinData::Record
  int32be :chunk_id
  int32le :chunk_size
  int32be :format
end

class FormatChunk < BinData::Record
  int32be :chunk_id
  int32le :chunk_size
  int16le :audio_format
  int16le :num_channels
  int32le :sample_rate
  int32le :byte_rate
  int16le :block_align
  int16le :bits_per_sample
end

class DataChunk < BinData::Record
  int32be :chunk_id
  int32le :chunk_size
  array :stream do
    int16le :left
    int16le :right
  end
end

class WavFormat < BinData::Record
  riff_chunk :riff_chunk
  format_chunk :format_chunk
  data_chunk :data_chunk
end