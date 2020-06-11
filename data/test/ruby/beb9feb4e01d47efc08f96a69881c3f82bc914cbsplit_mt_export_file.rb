#!/usr/bin/env ruby
# split an MT export file into 2MB chunks




def write_chunk(output_file_mask, counter, chunk) 
  out_filename = output_file_mask + counter.to_s + ".txt"
  outfile = File.new(out_filename,"w")
  outfile.write(chunk)
  outfile.close  
end




if ARGV.length != 1
  puts "Usage: split_mt_export_file [input_file] "
  exit 0
end  

input_filename = ARGV[0]


if ! File.file?(input_filename)
  puts "Error: input file <#{input_filename}> does not exist"
  exit 0
end


counter = 1
chunk = ""
MAX_CHUNK_SIZE = 2000000

input_file = File.open(input_filename)
output_file_mask =  input_filename.chomp(File.extname(input_filename)) + "_"


while (line = input_file.gets)
      if (line =~ /--------/) then
        chunk << line
        if (chunk.length > MAX_CHUNK_SIZE) then
          write_chunk(output_file_mask, counter,chunk)
          counter = counter + 1 
          chunk = ""
        end

      else
        chunk << line
        #puts line
      end
end

#handle last chunk
write_chunk(output_file_mask, counter,chunk)
input_file.close



