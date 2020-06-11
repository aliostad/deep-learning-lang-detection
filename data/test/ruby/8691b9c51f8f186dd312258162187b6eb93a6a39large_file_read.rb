require 'rubygems'

class File
  def self.sequential_read(file_path,chunk_size=nil)
    open(file_path) do |f|
      f.each_chunk(chunk_size) do |chunk|
        yield chunk
      end
    end
  end
  
  def each_chunk(chunk_size=1024)
    yield read(chunk_size) until eof?
  end  
  
end  

oldText = ARGV[1]
newText = ARGV[2]
CHUNK_SIZE = 10240000 # 10MB
p "ARGV[1] - #{oldText}"
p "ARGV[2] - #{newText}"

Dir["#{ARGV[0]}/*.csv"].each do |filename|
  p "Reading file - #{filename}"
  replaced_file = filename.gsub(/.csv/,'_replaced.csv')
  f = File.open(replaced_file,'w')
  File.sequential_read(filename,CHUNK_SIZE) do |chunk|
    chunk.each_line do |line|
      line.gsub!(oldText,newText)
      f.write line
    end  
  end
  f.close
  p "Replaced file = #{replaced_file}"
end  
