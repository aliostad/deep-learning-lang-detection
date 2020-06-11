# encoding: utf-8

module Aeee
  class Serializer
    module Encoding
      TRANSFER_ENCODING = 'Transfer-Encoding'.freeze
      CHUNKED = 'chunked'.freeze
      CHUNK = "%d\r\n%s\r\n".freeze
      CONTENT_LENGTH = 'Content-Length'.freeze

      def setup_body
        if finished.pending?
          setup_chunked_encoding
          setup_chunked_streaming
        else
          setup_identity_encoding
        end
      end

      def setup_chunked_encoding
        headers.delete(CONTENT_LENGTH)
        headers[TRANSFER_ENCODING] = CHUNKED
      end

      def setup_chunked_streaming
        finished.on_progress do |chunk|
          write_chunk(chunk)
        end
        finished.then { |_| write_chunk!('') }
      end

      def setup_identity_encoding
        headers.delete(TRANSFER_ENCODING)
        headers[CONTENT_LENGTH] = body.bytesize
      end

      def write_body
        if finished.pending?
          write_chunk(body)
        else
          write(body)
        end
      end

      def write_chunk(chunk)
        write_chunk!(chunk) unless chunk.empty?
      end

      def write_chunk!(chunk)
        write(body_chunk(chunk))
      end

      def body_chunk(chunk)
        sprintf(CHUNK, chunk.bytesize, chunk)
      end
    end
  end
end
