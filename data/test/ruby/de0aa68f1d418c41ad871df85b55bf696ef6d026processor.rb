# Copyright (c) 2008 Todd A. Fisher
require 'esi/parser'
require 'esi/response'

module ESI
  class Processor
    attr_reader :config, :router

    include ESI::Log

    def initialize( config, router, cache_buffer = nil )
      @config = config
      @router = router
      @chunk_count = 0
      @chunk_size = @config[:chunk_size] || 4096
      @bytes_sent = 0
      @max_depth = @config[:max_depth] || 3
      @chunk_buffer = StringIO.new # when buffer reaches chunk_size write to the http_response socket
      @parser = ESI::Parser.new( @chunk_buffer, @router, @config.cache, @max_depth )
      @cache_buffer = cache_buffer
    end
 
    def send_body( http_request, params, http_response, proxy_response )
      
      @http_response = http_response

      # prepare the parser given the raw request params and the preprocessed request params
      @parser.prepare( http_request.params, params )

      # feed data to the parser
      proxy_response.read_body do |data|
        @parser.process data
        @cache_buffer << data if @cache_buffer
        if @chunk_buffer.size > @chunk_size
          send_chunk
          @chunk_buffer = StringIO.new
          @parser.response.update_output( @chunk_buffer )
        end
      end

      @parser.finish 

      send_chunk

      [@chunk_count,@bytes_sent]
    rescue => e
      STDERR.puts "\n#{e.message}: #{e.backtrace.join("\n")}\n"
    ensure 
      http_response.write( "0\r\n\r\n" )
      http_response.done = true if http_response.respond_to?(:done)
    end

    def send_chunk
      @chunk_buffer.rewind
      size = @chunk_buffer.size
      chunk_header = "#{"%x" % size}" + Mongrel::Const::LINE_END
      #print chunk_header
      @http_response.write( chunk_header )  # write the chunk size
      @http_response.write( @chunk_buffer.read + Mongrel::Const::LINE_END )  # write the chunk
      @bytes_sent += size

      @chunk_count += 1
    end

  end
end
