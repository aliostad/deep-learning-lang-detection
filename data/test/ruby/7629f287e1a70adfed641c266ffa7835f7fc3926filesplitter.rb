#!/usr/bin/env ruby


class ChunkMaker
  
  def initialize( export_file, export_chunk_location, max_file_size = 1.2 )
    @export_chunk_count = 0
    @export_file = export_file
    @export_chunk_location = export_chunk_location
    @export_chunk_file_name = ''
    
    
    @buffer = ''
    @max_file_size = (1024 * 1024) * max_file_size
    @end_of_post = "--------\n"
    
  end  
  
  
  
  def write_chunk 

    @export_chunk_file_name = "#{@export_chunk_location}#{@export_chunk_count}.txt"
    export_chunk_file = File.new( @export_chunk_file_name, "w" )
    export_chunk_file.write( @buffer )
    export_chunk_file.close
    @export_chunk_count += 1
    @buffer = ''
    
    puts "Created and wrote to #{@export_chunk_file_name}"

  end
    
  
  def split_export_file
    
    if file = File.new(@export_file, "r")
      while (line = file.gets)
        # Collect buffer
        @buffer << line
        
        # Reached end of a post
        if line.eql? @end_of_post
        
          # One chunk done, write it out!
          if  @buffer.length > @max_file_size
            write_chunk
          end
        end
      end
      
      # Write out remaining buffer
      write_chunk
      file.close
    end  
  end
  

end






unless ARGV.length == 2
  puts "Dude, not the right number of arguments."
  puts "Usage: ruby filesplitter.rb export_file.txt export_split_directory\n"
  exit
end

export_file = ARGV[0]
export_chunk_location = ARGV[1]


chunk_maker = ChunkMaker.new(export_file, export_chunk_location)
chunk_maker.split_export_file

