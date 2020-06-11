#break document into chunks
#identify chunks by kind
#replace markdown i.ds with html ids
#output each return in order 

require 'minitest/autorun'
# require 'minitest/pride'
require_relative '../lib/chunk_identifier'

class ChunkIdentifierTest < Minitest::Test 

  def test_can_identify_an_h1_header

    chunk = '# My Life in Desserts'
    chunky = ChunkIdentifier.new
    assert_equal "header", chunky.identifier(chunk)
  end

  def test_can_identify_an_h2_header

    chunk = '## My Life in Desserts'
    chunky = ChunkIdentifier.new
    assert_equal "header", chunky.identifier(chunk)
  end  

  def test_can_identify_an_h3_header

    chunk = '### My Life in Desserts'
    chunky = ChunkIdentifier.new
    assert_equal "header", chunky.identifier(chunk)
  end

  def test_can_identify_an_h4_header

    chunk = '#### My Life in Desserts'
    chunky = ChunkIdentifier.new
    assert_equal "header", chunky.identifier(chunk)
  end

  def test_can_identify_an_h5_header

    chunk = '##### My Life in Desserts'
    chunky = ChunkIdentifier.new
    assert_equal "header", chunky.identifier(chunk)
  end

  def test_hashtag_must_be_at_beginning_to_be_a_header

    chunk = 'My Life in # Desserts'
    chunky = ChunkIdentifier.new
    assert_equal "paragraph", chunky.identifier(chunk)
  end  

  def test_can_identify_a_bulleted_list

    chunk = "* Sushi\n* Barbeque\n* Mexican"
    chunky = ChunkIdentifier.new
    assert_equal "list", chunky.identifier(chunk)
  end

  def test_can_identify_a_numbered_list

    chunk = "1. Sushi\n2. Barbeque\n3. Mexican"
    chunky = ChunkIdentifier.new
    assert_equal "list", chunky.identifier(chunk)
  end

end
