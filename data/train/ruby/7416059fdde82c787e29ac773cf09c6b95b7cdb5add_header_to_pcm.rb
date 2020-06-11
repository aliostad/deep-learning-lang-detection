# -*- coding: utf-8 -*-
def help
  warn "usage: cat pcm_file | ruby #{$0} sample_rate bitswidth channels > wave_file"
  exit(1)
end

sample_rate = ARGV.shift.to_i || help
bitswidth   = ARGV.shift.to_i || help
channels    = ARGV.shift.to_i || help

warn "sample_rate: #{sample_rate}"
warn "bitswidth: #{bitswidth}"
warn "channels: #{channels}"

$stdin.binmode
pcm_bytes = $stdin.read(nil)

fmt_chunk = 'fmt '
fmt_chunk << [16].pack('l') # size
fmt_chunk << [0x0001].pack('s')
fmt_chunk << [channels].pack('s')
fmt_chunk << [sample_rate].pack('l')
fmt_chunk << [sample_rate * channels * (bitswidth / 8)].pack('l') # データ速度
fmt_chunk << [channels * (bitswidth / 8)].pack('s') #blockalign
fmt_chunk << [bitswidth].pack('s')

data_chunk = 'data'
data_chunk << [pcm_bytes.length].pack('l')
data_chunk << pcm_bytes

riff_header = 'RIFF'
riff_header << [data_chunk.length + fmt_chunk.length + 4].pack('l')
riff_header << 'WAVE'

print riff_header
print fmt_chunk
print data_chunk
