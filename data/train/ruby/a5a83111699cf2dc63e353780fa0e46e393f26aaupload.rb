require 'vimeo_videos/upload/attributes'

module VimeoVideos
  # Handles checking space, splitting video into smaller chunks,
  # uploading them, veryfing them and a cleanup.
  class Upload
    # Video will be chunked in this directory.
    DEFAULT_TMP_DIR_PATH = 'tmp'

    # Default file size per chunk, 2 MB.
    DEFAULT_CHUNK_SIZE = 2 * 1024 * 1024

    # @param file_path [String] video file path
    # @param client    [Client] the client is used to call the API
    # @param options   [Hash]
    #   :temp_dir   - video will be chunked in this directory, defaults to 'tmp'
    #   :chunk_size - defaults to 2 MB
    def initialize(file_path, client, options = {})
      self.file_path        = file_path
      self.file_name        = File.basename(file_path)
      self.file_size        = File.size(file_path)
      self.client           = client
      self.temp_dir         = options[:temp_dir]   || DEFAULT_TMP_DIR_PATH
      self.chunk_size       = options[:chunk_size] || DEFAULT_CHUNK_SIZE
      self.chunks           = []
      self.number_of_chunks = (file_size.to_f / chunk_size).ceil
    end

    # Do the checking, splitting, uploading and cleanup.
    def upload!
      check_free_space!
      load_upload_ticket!
      check_upload_size!
      create_chunk_temp_dir!
      split_file_into_chunks!
      upload_chunks!
      verify_chunks!
      complete_upload!
    ensure
      delete_chunk_temp_dir!
    end

    # We need to check if there is enough space in the user's quota.
    def check_free_space!
      response   = client.request('vimeo.videos.upload.getQuota')
      free_space = response[:user][:upload_space][:free].to_i

      if file_size > free_space
        message = "Video size: #{ file_size }, free space: #{ free_space }"
        fail NoEnoughFreeSpaceError, message
      end
    end

    # Requests a new upload ticket and stores it in @ticket.
    def load_upload_ticket!
      response    = client.request('vimeo.videos.upload.getTicket')
      ticket      = response[:ticket]

      self.ticket = {
        id:              ticket[:id],
        endpoint_secure: ticket[:endpoint_secure],
        max_file_size:   ticket[:max_file_size].to_i
      }
    end

    # If a file is larger than an upload ticket allows, we are done.
    def check_upload_size!
      if file_size > ticket[:max_file_size]
        message = "Video size: #{ file_size }, ticket size: #{ ticket[:max_file_size] }"
        fail MaxFileSizeExceededError, message
      end
    end

    # Creates a temporary dir in @temp_dir
    def create_chunk_temp_dir!
      timestamp           = Time.now.strftime('%Y%m%d%H%M%S%L')
      chunk_temp_name     = "#{ file_name }_#{ timestamp }"
      self.chunk_temp_dir = temp_dir.join(chunk_temp_name)
      Dir.mkdir(chunk_temp_dir) unless chunk_temp_dir.exist?
    end

    # Split the video file into multiple pieces to speedup upload.
    def split_file_into_chunks!
      source_file = File.open(file_path, 'rb')

      number_of_chunks.times.each do |chunk_number|
        chunk = create_chunk(chunk_number, source_file)
        chunks << chunk
      end
    end

    # Read a part of video file and save it into a chunk file.
    #
    # @param chunk_number [Fixnum] chunk_number
    # @param source_file  [File]   the whole video file
    def create_chunk(chunk_number, source_file)
      chunk_name = "#{ file_name }.#{ chunk_number }"
      chunk_file = chunk_temp_dir.join(chunk_name)

      File.open(chunk_file, 'wb') do |f|
        f << source_file.read(chunk_size)
      end

      chunk_info = {
        number: chunk_number,
        file:   chunk_file,
        size:   File.size(chunk_file)
      }

      chunk_info
    end

    # Run through the chunks and upload them.
    def upload_chunks!
      client.upload_request(ticket, chunks)
    end

    # Get a verify ticket, run through the chunks and compare
    # the file sizes. If they match, good, if not, it's broke.
    def verify_chunks!
      params = {
        ticket_id: ticket[:id]
      }

      response        = client.request('vimeo.videos.upload.verifyChunks', params)
      response_chunks = response[:ticket][:chunks][:chunk]
      response_chunks = [ response_chunks ] if response_chunks.is_a?(Hash)

      verify_chunks_count(chunks, response_chunks)

      response_chunks.each do |their_chunk|
        our_chunk = chunks.find { |ch| ch[:number] == their_chunk[:id].to_i }
        verify_chunk(our_chunk, their_chunk)
      end
    end

    # Make sure we get the same number of chunks as we have.
    def verify_chunks_count(our_chunks, their_chunks)
      our_size   = our_chunks.size
      their_size = their_chunks.size

      if our_size != their_size
        message = "Chunk count doesn't match: our size: #{ our_size }, their size: #{ their_size }"
        fail ChunkCountError, message
      end
    end

    # Make sure each chunk has the same size as ours.
    def verify_chunk(our_chunk, their_chunk)
      if our_chunk[:size] != their_chunk[:size].to_i
        message = "Chunk #{ our_chunk[:id] }, our size: #{ our_chunk[:size] }, their size: #{ their_chunk[:size] }"
        fail ChunkSizeError, message
      end
    end

    # Mark the upload as complete and start processing the video
    # on Vimeo side.
    #
    # @return [String] video_id
    def complete_upload!
      params = {
        filename:  file_name,
        ticket_id: ticket[:id]
      }

      response = client.request('vimeo.videos.upload.complete', params)
      video_id = response[:ticket][:video_id]
      video_id
    end

    # Delete the temporary directory where chunks used to be.
    def delete_chunk_temp_dir!
      delete_chunks!

      return if !chunk_temp_dir || !chunk_temp_dir.exist?
      chunk_temp_dir.delete
    end

    # Goes through each chunk and deletes it.
    def delete_chunks!
      chunks.each do |chunk|
        next unless chunk[:file].exist?
        chunk[:file].delete
      end
    end
  end
end
