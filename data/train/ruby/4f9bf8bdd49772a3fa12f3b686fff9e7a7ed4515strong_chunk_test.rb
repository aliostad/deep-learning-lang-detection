require 'minitest/autorun'
require 'minitest/pride'
require './lib/strong_chunk'

class StrongChunkTest < Minitest::Test

  def test_it_has_the_input
    # skip
    input = "some stuff"
    strong_chunk = StrongChunk.new(input)

    assert_equal input, strong_chunk.text
  end

  def test_it_knows_when_its_not_strong
    input = "some stuff"
    strong_chunk = StrongChunk.new(input)

    refute strong_chunk.is_strong?(input)
  end

  def test_it_knows_when_its_strong
    input = "some **stuff**"
    strong_chunk = StrongChunk.new(input)

    assert strong_chunk.is_strong?(input)
  end

  def test_returns_input_when_input_does_not_contain_strong_markdown
    input = "no strong here"
    strong_chunk = StrongChunk.new(input)

    assert_equal input, strong_chunk.render
  end

  def test_replaces_strong_markdown_with_strong_html
    input = "some **stuff**"
    expected = "some <strong>stuff</strong>"
    strong_chunk = StrongChunk.new(input)

    assert_equal expected, strong_chunk.render
  end

  def test_replaces_multiple_strong_markdowns_with_html
    input = "**some** **stuff**"
    expected = "<strong>some</strong> <strong>stuff</strong>"
    strong_chunk = StrongChunk.new(input)

    assert_equal expected, strong_chunk.render
  end

  def test_acceptance
    # skip
    input = "<p>\"You just *have* to try the cheesecake,\" he said. \"Ever since **it** appeared in **Food & Wine** this place has been packed every night.\"</p>"
    expected = "<p>\"You just *have* to try the cheesecake,\" he said. \"Ever since <strong>it</strong> appeared in <strong>Food & Wine</strong> this place has been packed every night.\"</p>"
    strong_chunk = StrongChunk.new(input)

    assert_equal expected, strong_chunk.render
  end

end
