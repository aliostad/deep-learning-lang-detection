module PPTX
  module OPC
    class FilePart < BinaryPart
      def initialize(package, file)
        super(package, File.basename(file))
        @file = file
        @chunk_size = 16 * 1024
      end

      def marshal
        IO.read(@file)
      end

      def size
        File.size(@file)
      end

      def stream(out)
        File.open(@file, 'r') do |file|
          while chunk = file.read(@chunk_size)
            puts "Streaming file: #{chunk && chunk.bytesize} bytes"
            out << chunk
          end
        end
      end
    end
  end
end
