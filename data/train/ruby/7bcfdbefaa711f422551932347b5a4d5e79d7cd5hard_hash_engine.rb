# :nodoc: namespace
module SpStore

# :nodoc: namespace
module PChip

# Interface with hardware implementation of P chip's SHA-1 hash engine (FPGA)
class HardHashEngine 
  # @connector: connection to FPGA
  # data is divided into multiple chunks
  # each chunk is 512-bit (64 bytes)
  # each frame can have as most 20 chunks 
  def initialize()
    @connector           = nil
    @bytes_per_chunk     = 64
    @max_chunk_per_frame = 16
    @padding_chunk_num   = 5
    @byte_in_hash        = 20
    @frame_header = { :single => "\xf3",
                      :first  => "\xf2",
                      :middle => "\xf0",
                      :last   => "\xf1"
                    }
  end
  
  # sets the connected connection to P chip (FPGA)
  def set_connection(connector)
    @connector = connector
  end
  
  require 'timeout'
  # generates instructions to control FPGA to hash the given data
  def hash_block(data)
    chunk_num = data.length>>6
    frame_num = ( chunk_num.to_f / @max_chunk_per_frame ).ceil    
    byte_per_frame = @bytes_per_chunk*@max_chunk_per_frame
    padding_chunks = [0].pack('C')*@bytes_per_chunk*@padding_chunk_num
    
    if frame_num == 1 #single frame
      command = [ @frame_header[:last], frame_info(chunk_num, 1), data].join
      @connector.send command
    else
      @connector.send [ @frame_header[:first], frame_info(@max_chunk_per_frame, 1),
                        data[0, byte_per_frame], padding_chunks ].join
      byte_offset = byte_per_frame
      (2...frame_num).each do
        @connector.send [ @frame_header[:middle], frame_info(@max_chunk_per_frame, 1),
                          data[byte_offset, byte_per_frame], padding_chunks].join
        byte_offset += byte_per_frame
      end
      last_chunk_num = chunk_num % @max_chunk_per_frame
      last_chunk_num += @max_chunk_per_frame if last_chunk_num == 0
      @connector.send [ @frame_header[:last], frame_info(last_chunk_num, 1),
                        data[byte_offset, @bytes_per_chunk*last_chunk_num] ].join
    end    
    #hash_value = nil
    #Timeout::timeout(5) { hash_value = @connector.receive[1,@byte_in_hash] }
    #hash_value
    @connector.receive[1,@byte_in_hash]
  end
  
  # frame_info = { chunk_num(6 bit), block_num(2 bit) }
  def frame_info( chunk_num, block_num )
    [( chunk_num << 2 | (block_num-1) )].pack('C')
  end
    
end  # class SpStore::PChip::HardHashEngine
  
end  # namespace SpStore::PChip
  
end  # namespace SpStore
