require 'fog_storage'

class StoredChunk

  def self.save(filename, file, chunk_number)
    fog.create_file full_path(filename, chunk_number), file
  end

  def self.destroy(filename)
    fog.delete_file filename
  end

  def self.exists?(filename, chunk_number)
    fog.file_exists? full_path(filename, chunk_number)
  end

  def self.find(filename, chunk_number)
    fog.find_file full_path(filename, chunk_number)
  end

  def self.full_path(filename, chunk_number)
    File.join "#{filename}_chunks", chunk_number.to_s
  end

  def self.total(filename)
    fog.bucket.files.select { |f| f.key.match /#{filename}_chunks\// }.count
  end

  def self.join(filename, chunk_size)
    # Create a target file
    target_file = Tempfile.new(filename)
    target_file.binmode
    for i in 1..chunk_size.to_i
      # Select the chunk
      chunk = StoredChunk.find(filename, i)

      chunk.body.each_line do |line|
        target_file.write(line)
      end

      # Deleting chunk
      StoredChunk.destroy(chunk.key)
    end

    target_file.rewind

    fog.create_file(filename, target_file.read)
  end

  def self.fog
    @@fog ||= FogStorage.new
    @@fog
  end

end
