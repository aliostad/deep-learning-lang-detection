module UploadProgress
  class InputWrapper
    attr_reader :progress_id
    attr_reader :size
    attr_reader :received

    def initialize(env, progress_id, callback)
      @input       = env['rack.input']
      @size        = env['CONTENT_LENGTH'].to_i
      @received    = 0
      @progress_id = progress_id
      @callback    = callback
    end

    def rewind
      @input.rewind
    end

    def gets
      chunk = @input.gets
      self.increment(chunk)

      chunk
    end

    def read(*args)
      chunk = @input.read(*args)
      self.increment(chunk)

      chunk
    end

    def each
      @input.each do |chunk|
        self.increment(chunk)
        yield chunk
      end
    end

    def increment(chunk)
      if chunk.nil?
        @received = @size
      else
        @received += Rack::Utils.bytesize(chunk)
      end

      @callback.call(@progress_id, @received)

      return @received
    end
  end
end
