require 'png_chunk_types'

module PNGFileVerbose

  def info(file = nil)
    result = []

    header_chunk = chunks(PNGChunkTypes::IHDR).first

    result << "File Name: #{ File.basename(file.kind_of?(IO) ? file.path : file) }" if file
    result << ""
    result << "Header"
    result << "======"
    result << ""
    result << "  Width:              #{ header_chunk.width }"
    result << "  Height:             #{ header_chunk.height }"
    result << "  Bit Depth:          #{ header_chunk.bit_depth }"
    result << "  Colour Type:        #{ header_chunk.colour_type }"
    result << "  Compression Method: #{ header_chunk.compression_method }"
    result << "  Filter Method:      #{ header_chunk.filter_method }"
    result << "  Interlace Method:   #{ header_chunk.interlace_method }"
    result << ""
    result << "Chunks"
    result << "======"
    chunks.each do |chunk|
      result << "  %5s\t%10s bytes\t%12X" % [chunk.type, chunk.length, chunk.crc]
    end
    result << ""

    result
  end

end