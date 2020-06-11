class Dir

  # Chunk the all the files into chunks of a specified size
  # @param [String] Directory to chunk
  # @param [Integer] Size of chunk in bytes
  # @return [Array] Each element a list of files in the chunk
  #
  def self.chunk(dirname, size)
    chunks, chunk = [], []
    chunk_bytes = 0

    (Dir.glob(dirname + '/*') - ['.', '..']).each do |file|

      chunk_bytes += File.stat(file).size
      chunk << file

      if File.stat(file).size > size
        msg = "The size of #{file.split('/').last} is > #{size} (chunk size). Please choose a larger chunk size"
        raise RuntimeError, msg
        # chunk is full
      elsif chunk_bytes > size
        file_over = chunk.pop
        chunks << chunk
        # Reset for next chunk
        chunk_bytes = File.stat(file_over).size
        chunk = [file_over]
      end

    end
    chunks << chunk
  end
end