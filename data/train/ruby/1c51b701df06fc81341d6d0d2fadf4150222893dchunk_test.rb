require 'minitest/autorun'
require 'minitest/pride'
require './lib/chunk'

class ChunkTest < Minitest::Test
	attr_reader :chunk

	def setup
		@chunk = Chunk.new
	end

	def test_it_exists
		assert Chunk
	end

	def test_it_turns_text_into_anarray
		results = chunk.line_splitter("Paragraph1
			Paragraph2")
		what_it_is = results.is_a?(Array)
		assert what_it_is
	end

	def test_it_breaks_text_into_lines
		results = chunk.line_splitter("Paragraph1
			Paragraph2")
		assert ["Paragraph1","Paragraph2"], results
	end

	def test_it_can_break_up_multiple_paragraphs
		results = chunk.line_splitter("Paragraph1
			Paragraph2
			Paragraph3
			Paragraph4")
		assert ["Paragraph1","Paragraph2","Paragraph3","Paragraph4"], results
	end

	def test_it_handles_empty_lines
		results = chunk.line_splitter("Paragraph1

			Paragraph3")
			assert ["Paragraph1","","Paragraph3"], results
	end

	

end