class DosToUnixLines
  def initialize source_filepath, destination_filepath, chunk_size = 1.megabyte
    @source_filepath = source_filepath
    @destination_filepath = destination_filepath
    @chunk_size = chunk_size
  end

  def call
    File.open(source_filepath, 'r') do |text|
      File.open( destination_filepath, 'w' ) do |file|     
        file.write(text.read(chunk_size).gsub /\r/, "") until text.eof?
      end
    end
  end

private
  attr_reader :source_filepath, :destination_filepath, :chunk_size

end
