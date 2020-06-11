require 'fluent/plugin/buf_memory'

module Fluent
  class LighteningBufferChunk < MemoryBufferChunk
    attr_reader :record_counter

    def initialize(key, data='')
      super
      @record_counter = 0
    end

    def <<(data)
      super
      @record_counter += 1
    end
  end

  class LighteningBuffer < MemoryBuffer
    Fluent::Plugin.register_buffer('lightening', self)

    config_param :buffer_chunk_records_limit, :integer, :default => nil

    def configure(conf)
      super
    end

    def new_chunk(key)
      LighteningBufferChunk.new(key)
    end

    def storable?(chunk, data)
      return false if chunk.size + data.bytesize > @buffer_chunk_limit
      return false if @buffer_chunk_records_limit && chunk.record_counter >= @buffer_chunk_records_limit
      true
    end
  end
end
