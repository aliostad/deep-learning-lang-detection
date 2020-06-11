# The main idea here is to bypass the standard way the ruby driver handles data to be
# inserted into the GridFS (that is, byte-by-byte appraoch). Instead I try to write the
# entire chunks right away.
 
class GridFS::GridStore
    require 'mongo/util/byte_buffer'
    require 'mongo/gridfs/chunk'
    
    def fast_write(string)
      raise "#@filename not opened for write" unless @mode[0] == ?w
      #p "WRITE. " + (string.length / @chunk_size).to_s + " full chunks of " + @chunk_size.to_s + " B each plus " + (string.length % @chunk_size).to_s + " B rest."
      
      to_write = string.length
      while (to_write > 0) do
        step_size = (to_write > @chunk_size) ? @chunk_size : to_write
        @curr_chunk.data.put_array(ByteBuffer.new(string[-to_write,step_size]).to_a)
        to_write -= step_size
        if (to_write > 0) then
          prev_chunk_number = @curr_chunk.chunk_number
 
          # this is the bottleneck of the current solution - it takes the most time ...
          # ... but it is nothing surprising, since this is the actual data transfer code
          @curr_chunk.save
          @curr_chunk = GridFS::Chunk.new(self, 'n' => prev_chunk_number + 1)
        end
      end
      string.length - to_write
    end
 
    def fast_read()
      buf = ""
      while true do
        buf += @curr_chunk.data.to_s
        break if @curr_chunk.chunk_number == last_chunk_number
        @curr_chunk = nth_chunk(@curr_chunk.chunk_number + 1)
      end
      buf
    end
end

