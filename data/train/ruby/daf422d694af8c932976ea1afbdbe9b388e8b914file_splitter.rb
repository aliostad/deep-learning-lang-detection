module Cifrado

  class FileSplitter
    include Utils

    attr_reader :cache_dir
    attr_accessor :chunk_suffix

    # FileSplitter.new("elfari.webm", 10).split
    #
    # @param [String] file path to split
    # @param [Integer] number of chunks
    # @param [String] Destination directory of the chunks
    def initialize(filename, 
                   chunk_number = nil, 
                   cache_dir = Cifrado::Config.instance.cache_dir)
      raise ArgumentError.new unless File.exist?(filename)
      @filename = File.basename filename
      @source = filename
      @chunk_number = chunk_number || calculate_chunks(filename)
      
      # when we are splitting a file into a given number of chunks, 
      # the last chunk could be bigger than the others
      @each_size, @extra = File.size(filename).divmod(@chunk_number)
      @cache_dir = File.expand_path cache_dir
      @chunk_suffix = "/segments/#{'%.2f' % File.mtime(filename).to_f}/#{File.size(filename)}/"
    end

    def split
      file = File.new(@source, "rb")
      # create cache directory
      unless File.directory?(@cache_dir)
        Log.debug "Creating cache dir: #{@cache_dir}"
        FileUtils.mkdir_p(@cache_dir) 
      end

      chunks = []
      byte_count = 0
      chunk_n = 1
      chunk_name = @filename + "#{@chunk_suffix.gsub('/','-')}"
      chunk = File.join(@cache_dir, "#{chunk_name}#{'%08d' % chunk_n}")
      chunk_f = File.open(chunk, "wb")
      while read = file.read(4096) do
        if byte_count >= @each_size
          chunk_f.close
          chunks << chunk
          yield chunk_n, chunk if block_given?
          chunk_n += 1
          chunk = File.join(@cache_dir, "#{chunk_name}#{'%08d' % chunk_n}")
          chunk_f = File.open(chunk, "wb")
          byte_count = 0
        end
        chunk_f << read
        byte_count += 4096
      end
      chunk_f.flush
      yield chunk_n, chunk if block_given?
      chunks << chunk
      chunks
    ensure
      chunk_f.close unless chunk_f.closed?
      file.close unless file.closed?
    end

  end

end
