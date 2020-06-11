require 'minitest/autorun'
require 'minitest/pride'
require './lib/chunk_detector'

class ChunkDetectorTest < Minitest::Test
attr_reader :chunk_detector

	def setup
		@chunk_detector = ChunkDetector.new
	end

	def test_it_exists
		assert ChunkDetector
	end

	def test_it_evaluates_if_it_is_a_header
		results = chunk_detector.header?("# Paul Grever")
		assert results
	end

	def test_it_evalualtes_if_it_is_not_a_header
		results = chunk_detector.header?("Paul Grever")
		refute results
	end

	def test_it_determines_if_it_is_a_pargraph
		results = chunk_detector.paragraph?("Paul Grever")
		assert results
	end

	def test_it_determines_if_it_is_not_a_pargraph
		results = chunk_detector.paragraph?("# Paul Grever")
		refute results
	end

	def test_it_determines_if_it_is_a_header
	
		results = chunk_detector.header_grouper(["# Paul Grever"])
		assert_equal ["# Paul Grever"], results
	end

	def test_it_groups_the_headers
		results = chunk_detector.header_grouper(["# Paul Grever","#header2"])
		assert_equal ["# Paul Grever","#header2"], results 
	end

	def test_it_groups_only_items_that_are_headers
		results = chunk_detector.header_grouper(["# Paul Grever","not a header", "#header2"])
		assert_equal ["# Paul Grever","#header2"], results 
	end

	def test_it_groups_non_headers
		results = chunk_detector.non_header_grouper(["not a header"])
		assert_equal ["not a header"], results
	end

	def test_it_groups_only_non_headers
		results = chunk_detector.non_header_grouper(["# Paul Grever","not a header", "#header2", "still not a header"])
		assert_equal ["not a header", "still not a header"], results 
	end



	def test_it_finds_italic_words
		skip
		results = chunk_detector.italic?("*italic*")
		assert results

	end
 
end