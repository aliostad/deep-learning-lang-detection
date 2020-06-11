module Activefs
  class Rkchunker
    def initialize
      @hashlen=32
      @b=31
      @bit64=2**64-1
      @target=4096
      @min=2048
      @max=8192

      #@token=1
      #1.upto(@hashlen) do |multi|
      #  @token = (@token * @b) & @bit64
      #end

      @token = 3671467063254694913

      @lut=[]
      0.upto(255) do |idx|
        @lut[idx] = idx #(idx * token) & @bit64
      end
    end

    #@param IO io
    #@param block will be called with the chunk
    def chunk(io)

      hash=0
      off=0
      phase = 1 #there are two phases 1. hashing the first min bytes
                #                     2. finding the best chunk or max bytes

      the_chunk=io.read(@hashlen)
      return unless the_chunk
      yield off, 0, the_chunk && return if the_chunk.size < @hashlen

      #the first @hashlen bytes init the hash
      while off < @hashlen do
        hash = (((hash * @b) & @bit64)+ the_chunk.getbyte(off)) & @bit64
        off += 1
      end

      chunk_off=off
      window=the_chunk.bytes #a sliding window of the last @hashlen bytes
      digest=Digest::SHA2.new
      digest << the_chunk
      #go the next bytes go from byte 32 -
      io.each_byte do |byte| #integer!
        window << byte

        window_byte=window.shift

        hash= ((((hash-window_byte) & @bit64) * @b) + byte) & @bit64
        #puts "#{off} #{chunk_off} #{hash} #{window_byte} #{byte} #{phase} #{hash % @target} #{digest}"

        case
          when io.eof? # fire chunk if eof
            the_chunk << byte
            digest << [byte].pack("C")

            yield :eof, off, hash, the_chunk, digest.to_s
          when phase == 1 && (chunk_off == @min) #entering compare if min size is reached
            the_chunk << byte
            digest << [byte].pack("C")

            phase = 2
          when phase == 2 && (hash % @target == 1) #match? then we have a chunk
            yield :chunked, off, hash, the_chunk, digest.to_s

            phase = 1
            chunk_off = -1
            the_chunk=''
            digest=Digest::SHA2.new

            the_chunk << byte
            digest << [byte].pack("C")

            hash= ((((hash-window_byte) & @bit64) * @b) + byte) & @bit64 #the original code does a dubble hash on the edges
          when phase == 2 && (chunk_off == @max) #no match but max size reached
            yield :max, off, hash, the_chunk, digest.to_s
            phase = 1
            chunk_off = -1
            the_chunk=''
            digest=Digest::SHA2.new

            the_chunk << byte
            digest << [byte].pack("C")
          else
            the_chunk << byte
            digest << [byte].pack("C")
        end


        off += 1
        chunk_off += 1

      end
    end #chunk

  end
end