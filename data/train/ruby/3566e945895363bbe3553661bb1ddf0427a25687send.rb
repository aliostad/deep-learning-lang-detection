# #!/usr/bin/env ruby
require 'byebug'
require 'zlib'
require 'digest'

class Send
  DIGEST_SIZE = 16
  LENGTH_SIZE = 4
  CHUNK_SIZE = 1024

  def initialize
    @in_file = ARGF.file
  end

  def transfer
    chunks(@in_file).each do |chunk|
      STDOUT.write([Digest::MD5.hexdigest(chunk)].pack('H32'))

      compressed_chunk = Zlib::Deflate.deflate(chunk)

      STDOUT.write(chunk.length.to_s.split.pack("A#{LENGTH_SIZE}"))
      STDOUT.write(compressed_chunk.length.to_s.split.pack("A#{LENGTH_SIZE}"))

      if STDIN.read(1) == "y"
        STDOUT.write(compressed_chunk)
      end
    end
  end

  def chunks(str)
    Enumerator.new do |enum|
      while chunk = str.read(CHUNK_SIZE)
        enum << chunk
      end
    end
  end
end

Send.new.transfer
