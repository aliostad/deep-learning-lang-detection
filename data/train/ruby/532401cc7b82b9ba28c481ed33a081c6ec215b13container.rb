module Chunks
  class Container
    attr_reader :key, :title, :available_chunk_types
    attr_accessor :chunks
    
    def initialize(key, *available_chunk_types)
      begin
        @key = key.to_sym
      rescue NoMethodError
        raise Chunks::Error.new("Container key must be a symbol") 
      end
      @title = key.to_s.humanize.titlecase
      
      available_chunk_types = *available_chunk_types.first if available_chunk_types.first.is_a?(Array)
      available_chunk_types.each do |ac| 
        raise Chunks::Error.new("#{ac.inspect} is not a class") unless ac.is_a?(Class)
      end
      @available_chunk_types = available_chunk_types
      @chunks = []
    end
    
    def available_shared_chunks
      Chunks::SharedChunk.includes(:chunk).where("chunks_chunks.type in (?)", available_chunk_types.map(&:name))
    end
    
    def valid_chunks
      @chunks.select(&:valid?)
    end
  end
end