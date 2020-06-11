module UberUploader
  class FileUploader
    CHUNK_SIZE = 64000
    APP_ROOT_PATH = 'lib/uber_uploader/public'

    def initialize file_record, tmp_file
      @file_record = file_record
      @tmp_file = tmp_file
    end

    def upload_file_in_chunks
      while chunk = read_next_file_chunk
        write_to_file chunk
        increase_file_upload_size
      end
    end

    private
    def read_next_file_chunk
      @tmp_file.read(CHUNK_SIZE)
    end

    def write_to_file chunk
      FileStore.write "#{APP_ROOT_PATH}#{@file_record.path}", chunk
    end

    def increase_file_upload_size
      @file_record.increase_uploaded_size_by(CHUNK_SIZE)
    end
  end
end