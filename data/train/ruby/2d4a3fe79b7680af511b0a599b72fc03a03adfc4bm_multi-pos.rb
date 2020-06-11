require 'multi_thread_bench'
require 'helpers/simple_scanner_with_range'

class MultiThreadBenchWithRange < MultiThreadBench
  def encode input
    input = [input] unless input.is_a? Array
    NullEncoder.new.encode SimpleScannerWithRange.new(*input)
  end
end

MultiThreadBenchWithRange.new do |input, chunk_size, &encode|
  chunk_offsets = [0]
  
  input.lines.each_slice chunk_size do |lines|
    chunk_offsets << chunk_offsets.last + lines.join.bytesize
  end
  
  chunk_offsets.each_cons 2 do |this_chunk, next_chunk|
    encode[[input, this_chunk...next_chunk]]
  end
end
