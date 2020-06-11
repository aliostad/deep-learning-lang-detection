module NFAgent
  class LookUpError < StandardError; end
  class IgnoreLine < StandardError; end

  class ChunkHandler

    attr_accessor :chunk_group

    def initialize(options = {})
      @chunk_size = options[:chunk_size] || 500
      @parser = options[:parser] || Squiggle::SquidStandardParser.new(Config.time_zone)
      @chunk_group = {}
      class << @chunk_group
        def fetch!(key, new_chunk)
          if self.has_key?(key)
            self.fetch(key)
          else
            self[key] = new_chunk
            new_chunk
          end
        end
      end
    end

    def append(line)
      if Config.parse == 'locally'
        parsed = @parser.parse(line)
        return if parsed.invalid?
        if Config.mode == 'multi'
          begin
            key = MapperProxy.find_account_id(parsed.username, parsed.client_ip)
            # TODO: Still appending line as string until Server API has been updated
            return append2(line, key)
          rescue LookUpError, IgnoreLine
            return # Do nothing
          end
        end
      end
      # TODO: rename append2
      append2(line)
    end

    def append2(line, key = nil)
      key ||= 'all'
      begin
        chunk = @chunk_group.fetch!(key, Chunk.new(@chunk_size))
        chunk << line
      rescue ChunkExpired, ChunkFull
        Log.info("Chunk full or expired, cannot add lines")
        reset_chunk(key)
      end
    end

    def check_full_or_expired
      @chunk_group.each_pair do |key, chunk|
        if chunk.full?
          Log.info("Chunk Full: Resetting...")
          reset_chunk(key)
        elsif chunk.expired?
          Log.info("Chunk Expired: Resetting...")
          reset_chunk(key)
        end
      end
    end

    private
      def reset_chunk(key = nil)
        chunk = @chunk_group.delete(key || 'all')
        chunk.submit(key == 'all' ? nil : key)
      end
  end
end
