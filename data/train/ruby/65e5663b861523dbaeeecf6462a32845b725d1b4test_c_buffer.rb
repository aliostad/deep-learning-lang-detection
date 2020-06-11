require 'c_buffer'

repet   = 16 #126
chunk   = 1024*126
length  = chunk * 64
data    = Array.new(chunk){rand 255}

puts "data dump test"
  CBuffer.new( path: "./data", chunk: chunk, length: length ).tap{ |buf| 
    buf.output
    repet.times{ |i| buf.input.put_array_of_uchar 0, data }
    buf.stop
  }

puts "reader test"
  CBuffer.new( chunk: chunk, length: length ).tap{ |buf| 
    count = 0
    buf.read{ |data| puts "total data read: %i bytes" % count += data.length }
    repet.times{ |i| buf.input.put_array_of_uchar 0, data }
    buf.stop 
  }
