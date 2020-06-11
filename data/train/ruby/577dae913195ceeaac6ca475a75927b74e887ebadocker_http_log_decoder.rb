class DockerHTTPLogDecoder
  def initialize data_stream
    @data_stream = data_stream
  end

  def enumerate
    Enumerator.new do |yielder|
      docker_chunk_size = nil
      docker_stream_type = nil
      loop do
        raw_http_chunk_size = @data_stream.gets
        if raw_http_chunk_size.nil?
          return true
        end
        http_chunk_size = raw_http_chunk_size.strip.to_i
        docker_read = false
        if docker_chunk_size && docker_chunk_size != 0
          if docker_chunk_size == 0
            sleep 0.1
            next
          end
          http_chunk_body = @data_stream.read(docker_chunk_size.to_i)
          docker_read = true
          docker_chunk_size = nil
        else
          http_chunk_body = @data_stream.read(http_chunk_size)
        end
        @data_stream.read(2)
        if docker_read
          stream_type = case docker_stream_type
                        when 0
                          :STDIN
                        when 1
                          :STDOUT
                        when 2
                          :STDERR
                        end
          timestamp, message = http_chunk_body.split(' ', 2)
          yielder << [stream_type, timestamp, message.strip]
        end
        if http_chunk_size == 8
          docker_stream_type, docker_chunk_size = http_chunk_body.unpack("CxxxN")
        end
      end
    end
  end
end

