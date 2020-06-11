def checksum(len, addr, rectype, byteshex)
  (0x100 - ((len + addr + rectype + byteshex.map{|b| b.to_i(16)}.inject(0){|sum, b| b + sum}) & 0xFF)) & 0xFF
end

class Chunk
  attr_accessor :len, :lineaddr, :rectype, :checksum, :bytes
  
  def verify
    unless bytes.size == len
      raise "Expected #{len} bytes but only found #{bytes.size}"
    end
  end
end

infilename = ARGV.shift
lines = File.read(infilename)

chunks = []

for line in lines
  raise "missing starting colon: '#{line}'" unless line.start_with?(":")
  tokens = line[1..-1].scan(/../)

  chunk = Chunk.new

  chunk.len = tokens.shift.to_i(16)
  chunk.lineaddr = (tokens.shift + tokens.shift).to_i(16)
  chunk.rectype = tokens.shift.to_i(16)
  chunk.checksum = tokens.pop.to_i(16)
  chunk.bytes = tokens
  chunk.verify

  chunks << chunk
end

$stderr.puts "Read #{chunks.size} chunks from file"

lastaddr = 0
for chunk in chunks
  next if chunk.rectype != 0
  if chunk.lineaddr != lastaddr
    raise "Chunk #{chunk.lineaddr} is not contiguous with previous chunk #{lastaddr}"
  end
  lastaddr = chunk.lineaddr + chunk.len
end

blob = chunks.inject([]) {|blobs, chunk| blobs << chunk.bytes}.flatten

newchunks = []
addr = 0
while blob.size > 0
  bytes = blob.slice!(0, 32)
  puts ":#{bytes.size.to_s(16).rjust(2, '0')}#{addr.to_s(16).upcase.rjust(4, '0')}00#{bytes.join('')}#{checksum(bytes.size, addr, 0, bytes).to_s(16).rjust(2, '0').upcase}"
  addr += 32
end

puts ":00000001FF"