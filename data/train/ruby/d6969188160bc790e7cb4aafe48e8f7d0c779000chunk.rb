#!/usr/bin/env ruby
# Chops a file into parts with a particular number of lines

class Chunker
  MAX_CHUNKS=0xFFFFFFFF
  CHUNK_FILE_BASENAME="datachunk"
  META_DATA_FILE="datachunk_metadata.pl"

  def initialize(input_file, chunk_size)
    raise "No input file" if input_file.nil? 
    raise "Invalid input file" unless File.exists? input_file
    raise "Invalid chunk size" if chunk_size.nil? or 
    raise "Invalid chunk size" unless chunk_size=chunk_size.to_i and chunk_size > 0
    @chunk_size, @input_file = chunk_size, input_file
    @total_rules_read, @rules_in_last_chunk = 0, 0, 0
    create_chunks
    create_meta_data
  end

  def write_chunk(input, outputfilename)
    rules_in_prev_chunk = @rules_in_last_chunk
    @rules_in_last_chunk = 0
    File.open(outputfilename, "w") do |out|
      1.upto(@chunk_size) do
        line = input.gets
        if line.nil?
          @rules_in_last_chunk = rules_in_prev_chunk
          raise "end of file"
        end
        out << line
        @total_rules_read = @total_rules_read + 1
        @rules_in_last_chunk = @rules_in_last_chunk + 1
      end
    end
  end

  def create_chunks
    @chunk_files = []
    File.open(@input_file) do |input|
      begin
        1.upto(MAX_CHUNKS) do |chunkno|
          @chunk_files << CHUNK_FILE_BASENAME + chunkno.to_s + ".pl"
          write_chunk(input,@chunk_files.last)
          puts "Wrote #{@chunk_files.last}"
        end
      rescue Exception => e
        File.delete(@chunk_files.pop) if File.size(@chunk_files.last) == 0
        puts "done"
      end
    end
  end

  def create_meta_data
    File.open(META_DATA_FILE, "w") do |f|
      f << "total_inputs(#{@total_rules_read}).\n"
      f << "chunk_size(#{@chunk_size}).\n"
      f << "last_chunk_size(#{@rules_in_last_chunk}).\n"
      f << "chunks_total(#{@chunk_files.size}).\n"
    end
  end
end

Chunker.new(ARGV[0],ARGV[1])
