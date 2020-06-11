module Rubylet
  module Rack
    # Rails and possibly others manually set 'Transfer-Encoding:
    # chunked' and then send the body as chunks.  Java servlet
    # environment expects the server to handle chunking as needed
    # (e.g. when a response overflows the buffer and must be flushed to
    # the client before the servlet has closed the stream).
    #
    # This class makes the rather large assumption that {body#each}
    # iterates through the chunks, so we don't actually do much parsing.
    #
    # FIXME: ignores encoding?
    class DechunkingBody
      EOL = "\r\n".freeze

      CHUNK_START = Regexp.compile /^((\h+)#{Regexp.quote(EOL)})/

      def initialize(body)
        @body = body
      end

      def each
        @body.each do |chunk|
          yield chunk_to_part(chunk)
        end
      end

      def close
        @body.close
      end

      private

      def chunk_to_part(chunk)
        if chunk =~ CHUNK_START
          chunk_start = $1.bytesize
          chunk_length = $2.to_i(16)
          chunk.byteslice(chunk_start, chunk_length)
        else
          chunk
        end
      end
    end
  end
end
