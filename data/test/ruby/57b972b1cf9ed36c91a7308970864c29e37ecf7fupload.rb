module Concerns::Upload
  extend ActiveSupport::Concern

  def get_chunk
    render nothing: true, status: File.exists?(chunk_file_path) ? 200 : 404
  end

  def post_chunk!
    save_file!
    combine_file! if last_chunk?
    render nothing: true, status: 200
  # rescue
    # render nothing: true, status: 500
  end

  def options
    render nothing: true, status: 200
  end

private

  ##
  # Move the temporary Sinatra upload to the chunk file location
  def save_file!
    # Ensure required paths exist
    FileUtils.mkpath chunk_file_directory
    # Move the temporary file upload to the temporary chunk file path
    FileUtils.mv params['file'].tempfile, chunk_file_path, force: true
  end

  ##
  # Determine if this is the last chunk based on the chunk number.
  def last_chunk?
    params[:flowChunkNumber].to_i == params[:flowTotalChunks].to_i
  end

  ##
  # ./tmp/flow/abc-123/upload.txt.part1
  def chunk_file_path
    File.join(chunk_file_directory, "#{params[:flowFilename]}.part#{params[:flowChunkNumber]}")
  end

  ##
  # ./tmp/flow/abc-123
  def chunk_file_directory
    File.join Rails.root, "tmp", "flow", params[:flowIdentifier]
  end

  ##
  # Build final file
  def combine_file!
    # Ensure required paths exist
    FileUtils.mkpath final_file_directory
    # Open final file in append mode
    File.open(final_file_path, "a") do |f|
      file_chunks.each do |file_chunk_path|
        # Write each chunk to the permanent file
        f.write File.read(file_chunk_path)
      end
    end
    # Cleanup chunk file directory and all chunk files
    FileUtils.rm_rf chunk_file_directory
  end

  ##
  # /final/resting/place/upload.txt
  def final_file_path
    File.join final_file_directory, params[:flowFilename]
  end

  ##
  # /final/resting/place
  def final_file_directory
    File.join Rails.root, "public", "files"
  end

  ##
  # Get all file chunks sorted by cardinality of their part number
  def file_chunks
    Dir["#{chunk_file_directory}/*.part*"].sort_by {|f| f.split(".part")[1].to_i }
  end
end
