$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# The Gemfile is parsed into    file_chunks array
# Each chunk has the following attributes:  
#   :type - :static (don't sort them), :regular, :group (official group, use the header, end correctly)
#   :header - the line that prepends the chunk
#   :gem_hash - the hash of gems that belong to this chunk
# 

module Alphabetize
  VERSION = "0.1.3"

  def self.alphabetize_file(options = {})

    @@options = options
    @@options[:mode] ||= :verbose

    filename = "Gemfile"
    file = File.new(filename)

    lines = file.readlines
    puts "File Lines: #{lines.inspect}" if @@options[:mode] == :verbose
    file_chunks = make_chunky(lines)

    puts "Chunks: #{file_chunks.inspect}" if @@options[:mode] == :verbose

    backupFilename = "old_#{filename}"
    %x( mv #{filename} #{backupFilename})

    file = File.open(filename, 'w')
    # file.truncate(0) # clear the file

    file_chunks.each do |chunk|
      if chunk[:type] == :static
        print_gem_hash(file, chunk[:gem_hash])
      elsif chunk[:type] == :group
        file.puts(chunk[:header])
        print_gem_hash(file, chunk[:gem_hash])
        file.puts("end")
      elsif chunk[:type] == :regular
        print_gem_hash(file, chunk[:gem_hash])
      else
        raise "This chunk has some wierd type!"
      end


      # chunk.keys.sort.each do |gem|
      #   line = chunk[gem]
      #   file.puts(line)
      # end
      file.puts("")
    end

    file.close

  end

  private
  def self.make_chunky(lines)
    chunks = []

    chunk = {}
    chunk_gem_lines = []
    lines.each do |line|
      puts "*            Processing line: #{line}" if @@options[:mode] == :verbose
      if line != "\n"
        if line.match(/##/) # static chunk
          chunk[:type] = :static
          puts "Thinks its static" if @@options[:mode] == :verbose
          chunk[:gem_hash] = gem_hash([line])
          chunks << chunk
          chunk = {}
          chunk_gem_lines = []

        elsif line.match(/do/) # official start of a group
          chunk[:type] = :group
          chunk[:header] = line

        elsif line.match(/^end/) # official end of a group
          puts "Thinks its a group" if @@options[:mode] == :verbose
          chunk[:gem_hash] = gem_hash(chunk_gem_lines)
          chunks << chunk
          chunk = {}
          chunk_gem_lines = []

        else # regular gem line
          chunk[:type] = :regular if chunk == {} # start of a regualr chunk
          chunk_gem_lines << line
        end

      elsif line == "\n" and chunk != {}  # this is the end of some regular chunk
        puts "Thinks its regular" if @@options[:mode] == :verbose
        chunk[:gem_hash] = gem_hash(chunk_gem_lines)
        chunks << chunk
        chunk = {}
        chunk_gem_lines = []

      else # two new line characters in a row
        puts "**** Skipping line: #{line}" if @@options[:mode] == :verbose
        # do nothing
      end


      # if line contains '##'
      #   mark chunk as :static
      # if line contains 'do'
      #   mark chunk as :group
      # 
      # if line == "\n" and !chunk_gem_lines.empty?
      #   chunk[:gem_hash] = gem_hash(chunk_gem_lines)
      #   chunks << chunk
      #   chunk_gem_lines = [] # reset chunk lines
      # else
      #   chunk_gem_lines << line if line != "\n"
      # end
    end

    if chunk != {}
      chunk[:gem_hash] = gem_hash(chunk_gem_lines)
      chunks << chunk
    end

    chunks
  end

  def self.gem_hash(lines)
    hash = {}
    puts "-------- Inspecting lines: #{lines.inspect}" if @@options[:mode] == :verbose
    lines.each do |line|
      puts "Line: #{line}" if @@options[:mode] == :verbose
      match_data = line.scan(/(\"([^"]*)\")|(\'([^']*)\')/)
      # The gem is either the second element or the 4th element of the array
      gem ||= match_data[0][1]
      gem ||= match_data[0].last
      puts "Found gem: #{gem}" if @@options[:mode] == :verbose
      hash[gem] = line
    end

    hash
  end

  def self.print_gem_hash(out, hash)
    hash.keys.sort.each do |gem|
      line = hash[gem]
      out.puts(line)
    end
  end
end
