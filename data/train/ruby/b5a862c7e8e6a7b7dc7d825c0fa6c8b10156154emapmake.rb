require 'rubygems'
require 'gd2'

Dir['./data/*.gmp'].each do |filename|
  File.open(filename, 'rb') do |f|
    file_type = f.read(4)
    next if file_type != "GBMP"
    
    # usually 500
    version_code = f.read(2).unpack("S")[0]
    
    # extract all chunks from file
    chunks = []
    chunk_type = f.read(4)
    while(!chunk_type.nil?)
      chunk_size = f.read(4).unpack("I")[0]
      
      p [chunk_type, chunk_size]
      
      chunk_data = f.read(chunk_size)
            
      chunks << [chunk_type, chunk_size, chunk_data]
      
      # set up next loop
      chunk_type = f.read(4)
    end
    
    processed = {}
    
    chunks.each do |type, size, data|
      
    end
  end
end
