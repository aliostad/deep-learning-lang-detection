module VimeoVideos
  # Complicated upload request.
  class UploadRequest < BaseRequest
    # @return [Hash]
    #   :id
    #   :endpoint_secure
    #   :max_file_size
    attr_accessor :ticket

    # @return [Array<Hash>] Chunk is:
    #   :number
    #   :file
    #   :size
    attr_accessor :chunks

    # Run through the chunks and upload them in parallel.
    #
    # @param ticket [Hash]
    #   :id
    #   :endpoint_secure
    #   :max_file_size
    # @param chunks [Array<Hash>] Chunk is:
    #   :number
    #   :file
    #   :size
    def request(ticket, chunks)
      self.ticket = ticket
      self.chunks = chunks
      run_many_requests!
    end

    protected

    # Create chunk-upload requests and run them in parallel.
    def run_many_requests!
      hydra = Typhoeus::Hydra.new

      chunks.each do |chunk|
        request = new_request(chunk)
        hydra.queue(request)
      end

      hydra.run
    end

    # Make a Typhoeus::Request for chunk upload.
    #
    # @param chunk [Hash]
    #   :number
    #   :file
    #   :size
    def new_request(chunk)
      params = {
        ticket_id: ticket[:id],
        chunk_id:  chunk[:number].to_s
      }

      header  = new_header(params)
      request = new_typhoeus_request(chunk, header)

      request.on_complete do |response|
        response.success? || fail(ChunkUploadFailed, "Code: #{ response.code }, body: #{ response.body.strip }")
      end

      request
    end

    # Constructs a new SimpleOAuth::Header instance
    # ready to be used for Typhoeus request.
    #
    # @param params [Hash] HTTP parameters
    def new_header(params)
      SimpleOAuth::Header.new(
        :post,
        ticket[:endpoint_secure],
        params,
        client.oauth_options
      )
    end

    # Create a Typhoeus::Request.
    #
    # @param chunk [Hash]
    #   :number
    #   :file
    #   :size
    # @param header [SimpleOAuth::Header] OAuth headers
    def new_typhoeus_request(chunk, header)
      body = header.params.merge(
        file_data: File.open(chunk[:file], 'rb')
      )

      Typhoeus::Request.new(
        header.url,
        method: :post,
        params: header.params,
        body:   body,
        headers: {
          'User-Agent'    => USER_AGENT,
          'Authorization' => header.to_s
        }
      )
    end
  end
end
