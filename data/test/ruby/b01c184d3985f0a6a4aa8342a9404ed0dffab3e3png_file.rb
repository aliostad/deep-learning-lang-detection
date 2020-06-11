# direct port of python code at http://www.axelbrz.com.ar/?mod=iphone-png-images-normalizer
require 'zlib'

module IpaReader
  class PngFile
    def self.normalize_png(oldPNG)
      pngheader = "\x89PNG\r\n\x1a\n"

      if oldPNG[0...8] != pngheader
        return nil
      end
    
      newPNG = oldPNG[0...8]
  
      chunkPos = newPNG.length
  
      # For each chunk in the PNG file
      while chunkPos < oldPNG.length
        
        # Reading chunk
        chunkLength = oldPNG[chunkPos...chunkPos+4]
        chunkLength = chunkLength.unpack("N")[0]
        chunkType = oldPNG[chunkPos+4...chunkPos+8]
        chunkData = oldPNG[chunkPos+8...chunkPos+8+chunkLength]
        chunkCRC = oldPNG[chunkPos+chunkLength+8...chunkPos+chunkLength+12]
        chunkCRC = chunkCRC.unpack("N")[0]
        chunkPos += chunkLength + 12

        # Parsing the header chunk
        if chunkType == "IHDR"
          width = chunkData[0...4].unpack("N")[0]
          height = chunkData[4...8].unpack("N")[0]
        end
    
        # Parsing the image chunk
        if chunkType == "IDAT"
          # Uncompressing the image chunk
          inf = Zlib::Inflate.new(-Zlib::MAX_WBITS)
          chunkData = inf.inflate(chunkData)
          inf.finish
          inf.close
  
          # Swapping red & blue bytes for each pixel
          newdata = ""
      
          height.times do 
            i = newdata.length
            newdata += chunkData[i..i].to_s
            width.times do
              i = newdata.length
              newdata += chunkData[i+2..i+2].to_s
              newdata += chunkData[i+1..i+1].to_s
              newdata += chunkData[i+0..i+0].to_s
              newdata += chunkData[i+3..i+3].to_s
            end
          end

          # Compressing the image chunk
          chunkData = newdata
          chunkData = Zlib::Deflate.deflate( chunkData )
          chunkLength = chunkData.length
          chunkCRC = Zlib.crc32(chunkType)
          chunkCRC = Zlib.crc32(chunkData, chunkCRC)
          chunkCRC = (chunkCRC + 0x100000000) % 0x100000000
        end
    
        # Removing CgBI chunk 
        if chunkType != "CgBI"
          newPNG += [chunkLength].pack("N")
          newPNG += chunkType
          if chunkLength > 0
            newPNG += chunkData
          end
          newPNG += [chunkCRC].pack("N")
        end

        # Stopping the PNG file parsing
        if chunkType == "IEND"
          break
        end
      end
   
      return newPNG
    end
  end
end