module Codnar

  # Read chunks from disk files.
  class Reader

    # Load all chunks from the specified disk files to memory for later access
    # by name.
    def initialize(errors, paths)
      @errors = errors
      @chunks = {}
      @used = {}
      paths.each do |path|
        read_path_chunks(path)
      end
    end

    # Fetch a chunk by its name.
    def [](name)
      id = name.to_id
      @used[id] = true
      return @chunks[id] ||= (
        @errors << "Missing chunk: #{name}"
        Reader.fake_chunk(name)
      )
    end

    # Collect errors for unused chunks.
    def collect_unused_chunk_errors
      @chunks.each do |id, chunk|
        @errors.push("#{$0}: Unused chunk: #{chunk.name} #{Reader.locations_message(chunk)}") unless @used[id]
      end
    end

  protected

    # Load and merge all chunks from a disk file into memory.
    def read_path_chunks(path)
      @errors.in_path(path) do
        chunks = load_path_chunks(path)
        next unless chunks
        merge_loaded_chunks(chunks)
        @root_chunk ||= chunks[0].name
      end
    end

    # Load all chunks from a disk file into memory.
    def load_path_chunks(path)
      chunks = YAML.load_file(path)
      @errors << "Invalid chunks data" unless chunks
      # TODO: A bit more validation would be nice.
      return chunks
    end

    # Merge an array of chunks into memory.
    def merge_loaded_chunks(chunks)
      chunks.each do |new_chunk|
        old_chunk = @chunks[id = new_chunk.name.to_id]
        if old_chunk.nil?
          @chunks[id] = new_chunk
        elsif Reader.same_chunk?(old_chunk, new_chunk)
          Reader.merge_same_chunks(old_chunk, new_chunk)
        else
          @errors.push(Reader.different_chunks_error(old_chunk, new_chunk))
        end
      end
    end

    # Merge a new "same" chunk into an old one.
    def self.merge_same_chunks(old_chunk, new_chunk)
      old_chunk.locations = \
        (old_chunk.locations + new_chunk.locations).uniq.sort \
          do |first_location, second_location|
            [ first_location.file.to_id, first_location.line ] \
            <=> [ second_location.file.to_id, second_location.line ]
          end
      old_chunk.containers = \
        (old_chunk.containers + new_chunk.containers).uniq.sort \
          do |first_name, second_name|
            first_name.to_id <=> second_name.to_id
          end
    end

    # Check whether two chunks contain the same "stuff".
    def self.same_chunk?(old_chunk, new_chunk)
      return Reader.chunk_payload(old_chunk) == Reader.chunk_payload(new_chunk)
    end

    # Return just the actual payload of a chunk for equality comparison.
    def self.chunk_payload(chunk)
      chunk = chunk.reject { |key, value| [ "locations", "name", "containers" ].include?(key) }
      chunk.contained.map! { |name| name.to_id }
      return chunk
    end

    # Error message when two different chunks have the same name.
    def self.different_chunks_error(old_chunk, new_chunk)
      old_location = Reader.locations_message(old_chunk)
      new_location = Reader.locations_message(new_chunk)
      return "#{$0}: Chunk: #{old_chunk.name} is different #{new_location}, and #{old_location}"
    end

    # Format a chunk's location for an error message.
    def self.locations_message(chunk)
      locations = chunk.locations.map { |location| "in file: #{location.file} at line: #{location.line}" }
      return locations.join(" or ")
    end

    # Return a fake chunk for the specified name.
    def self.fake_chunk(name)
      return {
        "name" => name,
        "locations" => [ { "file" => "MISSING" } ],
        "contained" => [],
        "containers" => [],
        "html" => "<div class='missing chunk error'>\nMISSING\n</div>"
      }
    end

  end

end
