require 'mc_proxy/packets/base'

module McProxy::Packets
  class MapChunk < Base

    schema do
      byte :packet_id
      int   :x
      short :y
      int   :z
      byte  :size_x
      byte  :size_y
      byte  :size_z
      int   :chunk_size
      
      # puts "Chunk SIZE == #{field(:chunk_size)}"

      ensure_size!(field(:chunk_size))
      @offset += field(:chunk_size)
      # field(:chunk_size).times do |idx|        
      #   parse_byte_field
      # end
      
    end
    
    def to_s
      "<MapChunk x=#{@x} y=#{@y} z=#{@z} size_x=#{@size_x} size_y=#{@size_y} size_z=#{@size_z} chunk_size=#{@chunk_size} total_size=#{self.bytesize}>"
    end
    
  end
end