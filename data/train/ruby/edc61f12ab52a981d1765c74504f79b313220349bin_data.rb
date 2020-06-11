class BinData
  def self.chunk(myBlob, chunkSize)
    # split blob into chunks where chunk.size <= chunkSize
    myBlob = myBlob.to_data unless myBlob.is_a?(NSData)
    return [""] if myBlob.length == 0
    retval = []
    length = myBlob.length
    offset = 0
    while offset < length
      thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
      chunk = NSData.dataWithBytesNoCopy myBlob.bytes + offset,
                                         length:thisChunkSize,
                                         freeWhenDone: false
      offset += thisChunkSize
      # do something with chunk
      retval << zlib_deflate(chunk)
      #retval << chunk
    end
    retval
  end
  def self.zlib_deflate nsdata
    # we must provide extra buffer because
    # short strings such as "9" might deflate into a longer string "x\xDA\xB3\x04\x00\x00:\x00:"
    out_data = NSMutableData.alloc.initWithLength([nsdata.length, 256].max)
    ret = zcompress(nsdata.bytes, nsdata.length, out_data.bytes, out_data.length)
    return ret if ret < 0
    out_data.setLength(ret)
    out_data
  end
end # class BinData
