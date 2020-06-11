require 'rfuzz/client'
require 'pushbackiond'

class StreamingHttpClient < RFuzz::HttpClient
    def initialize(host, port, options = {})
        super(host, port, options)
        @chunk_size = options[:chunksize] || CHUNK_SIZE
    end

   def sendrecv_streaming_request(method, uri, req, &chunk_handler)
      begin
        notify :connect do
          @sock = PushBackIoNd.new(TCPSocket.new(@host, @port))
        end

        out = StringIO.new
        body = build_request(out, method, uri, req)

        notify :send_request do
          @sock.write(out.string + body)
          @sock.flush
        end

        read_streaming_response(&chunk_handler)
      rescue Object
        raise $!
      ensure
        if @sock
          notify(:close) { @sock.close }
        end
      end
    end

    def read_streaming_response(&chunk_handler)
        resp = nil

        notify :read_header do
          resp = read_parsed_header
        end
    
        notify :read_body do
          #Yield any part of the body already read, and anything still in 
          #the pushbackio buffer
          chunk_handler.call(resp.http_body) unless resp.http_body.length == 0
          while true
              chunk = @sock.pop(@chunk_size)
              chunk_handler.call(chunk) unless chunk.length == 0

              break unless chunk.length == @chunk_size
          end

          read_buffer = ""
          if resp.chunked_encoding?
            raise ArgumentError,'Chunked encoding is not supported'
          elsif resp[CONTENT_LENGTH]
            needs = resp[CONTENT_LENGTH].to_i - resp.http_body.length
            while needs > 0
                @sock.secondary.read(needs > @chunk_size ? @chunk_size : needs, read_buffer)
                chunk_handler.call(read_buffer)
                needs -= read_buffer.length
            end
          else
            while true
              @sock.secondary.readpartial(@chunk_size, read_buffer)
              chunk_handler.call(read_buffer) unless read_buffer.length == 0
              break unless read_buffer.length > 0
            end
          end
        end
    end
end
