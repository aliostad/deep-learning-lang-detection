module Sublimate
  #todo: This seems like it could just be IO objects that map to portions of a file
  class ChunkedFile
    def self.default_chunk_size
      @default_chunk_size ||= (1024 * 1024 * 500) 
    end
    def self.default_chunk_size=(v)
      @default_chunk_size = v
    end
    def initialize(path, opts={})
      @path = path
      @chunk_size = opts[:chunk_size] || self.class.default_chunk_size
    end

    def each_chunk
      counter = 0
      offset = 0
      file_size = File.size(@path)
      while offset < file_size
        data = IO.read(@path, @chunk_size, offset)
        details = {:counter => counter }
        yield(data, details)
        offset += @chunk_size
        counter += 1
      end
    end
  end
end
