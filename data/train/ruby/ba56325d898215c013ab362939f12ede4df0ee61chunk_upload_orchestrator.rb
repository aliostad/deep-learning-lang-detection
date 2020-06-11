# manages the process of receiving a chunk, writing it to disk
# updating the DB, sending the chunk to AWS, verifying send
# updating the DB, deleting the chunk from file system and
# creating the next chunk record and returning that to client side code

class ChunkUploadOrchestrator
  attr_reader :errors

  def self.for(args={})
    cuo = new(args)
    cuo.call
    cuo
  end

  def initialize(args)
    @chunk_sent_id = args.fetch(:chunk_id)
    @chunk_file_data = args.fetch(:chunk_file_data)
    @errors = []
  end

  def call
    uamc = UploadAwsMultipartChunk.for(
      vault_name: upload.vault.name,
      chunk_id: chunk_sent_id,
      body: chunk_file_data
    )
    if uamc.errors?
      self.errors << uamc.errors.join(' ')
      return # bail out
    else
      if upload.all_chunks_completed?
        CompleteAwsMultipartUpload.for(
          vault_name: upload.vault.name,
          upload_id: upload.id
        )
      end
    end
  end

  def next_chunk
    if upload.chunks.size < upload.final_expected_chunk_count
      @next_chunk ||= Chunk.create_next_chunk(upload.id, 'Upload')
    end
  end

  def errors?
    errors.any?
  end

  def chunk_sent
    @chunk_sent ||= Chunk.where(id: chunk_sent_id).first
  end

  private

  attr_reader :chunk_sent_id, :chunk_file_data
  attr_writer :errors

  def upload
    chunk_sent.chunkable
  end
end