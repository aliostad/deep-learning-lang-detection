
require './lib/chunk_detector'
require './lib/heading'
require './lib/paragraph'
require './lib/chunk'
class Chisel
	attr_reader :chunk, :chunk_detector, :header, :paragraph

	def initialize 
		@chunk = Chunk.new
		@chunk_detector = ChunkDetector.new
		@header = Heading.new
		@paragraph = Paragraph.new
	end
 

	def lines(input)
		@chunk.line_splitter(input)
	end

	def header_seperator(input)
		by_line = lines(input)
		header = @chunk_detector.header_grouper(by_line)
	end
end

test = Chisel.new
t1 = test.header_seperator("Paragrah1 Paragraph2 # header")
p t1