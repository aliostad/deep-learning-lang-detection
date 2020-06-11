class MessageChunker
  attr_accessor :chunk_size

  def initialize(options={})
    @chunk_size = options.fetch(:chunk_size, 1000)
  end

  def chunk(message)
    chunks      = message.scan(/[\w|\W]{1,#{@chunk_size}}/)
    total_count = chunks.length
    last_chunk  = total_count-1
      
    chunks.map.with_index do |msg, index|
      position = :first if index == 0
      position = :last if index == last_chunk

      chunk = { response: msg, number: index+1, total: total_count }
      chunk.merge!(position: position) unless position.nil?

      chunk
    end
  end
end
