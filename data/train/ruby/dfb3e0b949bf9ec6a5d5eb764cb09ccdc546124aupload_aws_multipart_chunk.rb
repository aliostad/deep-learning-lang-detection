class UploadAwsMultipartChunk < AwsRequest
  def call
    begin
      resp = glacier.upload_multipart_part(
        account_id: '-',
        vault_name: vault.name,
        upload_id: aws_job_id,
        range: "bytes #{chunk.byte_range}/*",
        body: body
      )
      chunk.sha256_checksum = resp.checksum
      chunk.status = :completed
      upload.status = :partially_completed
      upload.save!
    rescue Aws::Glacier::Errors::ServiceError => e
      log_aws_error(e)
      add_aws_error(e)
      chunk.status = :failed
    ensure
      chunk.save!
    end
  end

  private

  attr_reader :vault_name, :chunk_id, :body

  def post_initialize_hook(args)
    @vault_name = args.fetch(:vault_name)
    @chunk_id = args.fetch(:chunk_id)
    @body = args.fetch(:body)
  end

  def chunk
    @chunk ||= Chunk.where(id: chunk_id).first
  end

  def upload
    chunk.chunkable
  end

  def vault
    chunk.vault
  end

  def aws_job_id
    upload.aws_job_id
  end
end