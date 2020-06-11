module Codnar

  # Merge classified lines into chunks.
  class Merger

    # Convert classified lines from a disk file into chunks.
    def self.chunks(errors, path, lines)
      return Merger.new(errors, path, lines).chunks
    end

    # Return merged chunks containing the classified lines. Each chunk lines
    # are only indented relative to the chunk. This allows nested chunks to be
    # presented unindented in the final weaved HTML.
    def chunks
      @chunks = [ file_chunk ]
      @stack = @chunks.dup
      @errors.in_path(@path) { merge_lines }
      @chunks.each { |chunk| Merger.unindent_lines(chunk.lines) }
      return @chunks
    end

  protected

    # Convert classified lines from a disk file into chunks.
    def initialize(errors, path, lines)
      @errors = errors
      @path = path
      @lines = lines
    end

    # The top-level all-the-disk-file chunk (without any classified lines)
    def file_chunk
      return { 
        "name" => @path,
        "locations" => [ { "file" => @path, "line" => 1 } ],
        "containers" => [],
        "contained" => [],
        "lines" => []
      }
    end

    # {{{ Merging nested chunk lines

    # Merge all the classified lines into chunks
    def merge_lines
      @lines.each do |line|
        @errors.at_line(line.number)
        merge_line(line)
      end
      end_unterminated_chunks
    end

    # End all chunks missing a terminating end chunk classified line.
    def end_unterminated_chunks
      @stack.shift
      @stack.each do |chunk|
        @errors << "Missing end line for chunk: #{chunk.name}"
      end
    end

    # Merge the next classified line.
    def merge_line(line)
      case line.kind
      when "begin_chunk"
        begin_chunk_line(line)
      when "end_chunk"
        end_chunk_line(line)
      else
        @stack.last.lines << line
      end
    end

    # Merge a classified line that starts a new chunk.
    def begin_chunk_line(line)
      chunk = contained_chunk(container = @stack.last, line)
      container.contained << chunk.name
      container.lines << line.merge("kind" => "nested_chunk")
      @chunks << chunk
      @stack << chunk
    end

    # A chunk contained in another chunk.
    def contained_chunk(container, line)
      return {
        "name" => new_chunk_name(line.payload),
        "locations" => [ { "file" => @path, "line" => line.number } ],
        "containers" => [ container.name ],
        "contained" => [],
        "lines" => [ line ]
      }
    end

    # Return the name of a new chunk.
    def new_chunk_name(name)
      return name unless name.nil? || name == ""
      @errors << "Begin line for chunk with no name"
      return "#{@path}/#{@chunks.size}"
    end

    # Merge a classified line that ends an existing chunk.
    def end_chunk_line(line)
      return missing_begin_chunk_line(line) if @stack.size == 1
      chunk = @stack.last
      @errors << "End line for chunk: #{line.payload} mismatches begin line for chunk: #{chunk.name}" \
        unless Merger.matching_end_chunk_line?(chunk, line)
      chunk.lines << line
      @stack.pop
    end

    # Check whether an end chunk classified line matches the begin chunk
    # classified line.
    def self.matching_end_chunk_line?(chunk, line)
      line_name = line.payload
      return line_name.to_s == "" || line_name.to_id == chunk.name.to_id
    end

    # }}}

    # {{{ Unindenting chunk lines

    # Remove the common indentation from a sequence of classified lines.
    def self.unindent_lines(lines)
      indentation = Merger.minimal_indentation(lines)
      lines.each do |line|
        line.indentation = line.indentation.andand.unindent(indentation)
      end
    end

    # Find out the minimal indentation of all the classified lines.
    def self.minimal_indentation(lines)
      return lines.map { |line| line.indentation }.compact.min
    end

    # }}}

  end

end
