require 'minitest/autorun'
require 'minitest/pride'
require './lib/chunk_maker'

class ChunkMakerTest < Minitest::Test

  def test_text_split_into_chunks
    string = "asdf\n\nasdf"
    chunker = ChunkMaker.new(string)
    assert_equal ["asdf", "asdf"], chunker.chunk
  end

  def test_one_line_break_stays_one_chunk
    string = "asdf\nasdf"
    chunker = ChunkMaker.new(string)
    assert_equal ["asdf\nasdf"], chunker.chunk
  end

  def test_longer_string
    string = "zxcv\n\nzxcv\n\nasdf"
    chunker = ChunkMaker.new(string)
    assert_equal ["zxcv", "zxcv", "asdf"], chunker.chunk
  end
end
