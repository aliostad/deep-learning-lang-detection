require 'minitest/autorun'
require 'minitest/pride'
require './lib/em_chunk'


class EmChunkTest < Minitest::Test

  def test_input_doesnt_contain_em_markdown
    input = "no em here"
    em_chunk = EmChunk.new(input)

    refute em_chunk.contains_em_markdown?(input)
  end

  def test_input_does_contain_em_markdown
    # skip
    input = "there is *em* here"
    em_chunk = EmChunk.new(input)

    assert em_chunk.contains_em_markdown?(input)
  end

  def test_replaces_em_markdown_with_html
    input = "there is *em* here"
    expected = "there is <em>em</em> here"
    em_chunk = EmChunk.new(input)

    assert_equal expected, em_chunk.render
  end

  def test_replaces_multiple_em_markdowns_with_html
    # skip
    input = "*there* is *em* here"
    expected = "<em>there</em> is <em>em</em> here"
    em_chunk = EmChunk.new(input)

    assert_equal expected, em_chunk.render
  end

  def test_acceptance
    # skip
    input = "You just *have* to *try* the cheesecake,\" he said. \"Ever since it appeared in <strong>Food & Wine</strong> this place has been packed every night."
    expected = "You just <em>have</em> to <em>try</em> the cheesecake,\" he said. \"Ever since it appeared in <strong>Food & Wine</strong> this place has been packed every night."
    em_chunk = EmChunk.new(input)

    assert_equal expected, em_chunk.render
  end
end
