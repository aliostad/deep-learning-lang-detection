require 'fluent/plugin/buf_file'

module Fluent
  class PullBufferChunk < FileBufferChunk
    attr_accessor :flushed

    def initialize(key, path, unique_id, mode="a+", symlink_path = nil)
      super
      @flushed = false
    end

    def purge
      # do not anything if not flushed yet: call actual_purge explicitly.
      if @flushed
        actual_purge
      end
    end

    def actual_purge
      @file.close
      File.unlink(@path) rescue nil # TODO: check @path exists or not, and remove-or-rename if exists
    end
  end

  class PullPoolBuffer < FileBuffer
    Plugin.register_buffer('pullpool', self)

    def initialize
      super
      @mutex = Mutex.new
      @pool = []
    end

    def write_chunk(chunk, out)
      if out.respond_to?(:write) # for normal BufferedOutput plugins: works just same as FileBuffer
        out.write(chunk)
        chunk.flushed = true
      else
        @pool.push(chunk)
      end
    end

    def pull_chunks
      raise "BUG: block not given" unless block_given?
      chunks = nil
      @mutex.synchronize do
        chunks = @pool
        @pool = []
      end
      chunks.each do |chunk|
        begin
          yield chunk
          chunk.actual_purge
        rescue => e
          # TODO: Chunks should be returned to @pool ?
          #       It may make infinite error loops. Hmmm....
        end
      end
    end

    def new_chunk(key) # copy&paste from FileBuffer, but s/FileBufferChunk/PullBufferChunk/
      encoded_key = encode_key(key)
      path, tsuffix = make_path(encoded_key, "b")
      unique_id = tsuffix_to_unique_id(tsuffix)
      PullBufferChunk.new(key, path, unique_id, "a+", @symlink_path)
    end

    def resume # copy&paste from FileBuffer, but s/FileBufferChunk/PullBufferChunk/
      maps = []
      queues = []

      Dir.glob("#{@buffer_path_prefix}*#{@buffer_path_suffix}") {|path|
        match = path[@buffer_path_prefix.length..-(@buffer_path_suffix.length+1)]
        if m = PATH_MATCH.match(match)
          key = decode_key(m[1])
          bq = m[2]
          tsuffix = m[3]
          timestamp = m[3].to_i(16)
          unique_id = tsuffix_to_unique_id(tsuffix)

          if bq == 'b'
            chunk = PullBufferChunk.new(key, path, unique_id, "a+")
            maps << [timestamp, chunk]
          elsif bq == 'q'
            chunk = PullBufferChunk.new(key, path, unique_id, "r")
            queues << [timestamp, chunk]
          end
        end
      }

      map = {}
      maps.sort_by {|(timestamp,chunk)|
        timestamp
      }.each {|(timestamp,chunk)|
        map[chunk.key] = chunk
      }

      queue = queues.sort_by {|(timestamp,chunk)|
        timestamp
      }.map {|(timestamp,chunk)|
        chunk
      }

      return queue, map
    end

  end
end
