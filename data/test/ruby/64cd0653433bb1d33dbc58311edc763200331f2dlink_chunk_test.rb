require 'minitest/autorun'
require 'minitest/pride'
require './lib/link_chunk'

class LinkChunkTest < Minitest::Test

  def test_has_original_markdown
    input      = "[an example](http://example.com/)"
    link_chunk = LinkChunk.new(input)

    assert_equal input, link_chunk.markdown
  end

  def test_input_does_not_contain_link_markdown
    input      = "http://example.com/"
    link_chunk = LinkChunk.new(input)

    refute link_chunk.contains_link_markdown?(input)
  end

  def test_input_contains_link_markdown
    input      = "(http://example.com/)"
    link_chunk = LinkChunk.new(input)

    assert link_chunk.contains_link_markdown?(input)
  end

  def test_surrounds_markdown_link_text_with_a_tag
    input      = "[an example]"
    expected   = "<a>an example</a>"
    link_chunk = LinkChunk.new(input)

    result = link_chunk.add_link_text(input)

    assert_equal expected, result
  end

  def test_adds_markdown_link_to_http_attribute
    input      = "(http://example.com/)"
    expected   = "href=\"http://example.com/\""
    link_chunk = LinkChunk.new(input)

    result = link_chunk.add_href_attribute(input)

    assert_equal expected, result
  end

  def test_adds_markdown_title_to_title_attribute
    # skip
    input      = "\"Title\""
    expected   = "title=\"Title\""
    link_chunk = LinkChunk.new(input)

    result = link_chunk.add_title_attribute(input)

    assert_equal expected, result
  end

  def test_acceptance_without_title
    # skip
    input      = "some text before [an example](http://example.com/) some text after"
    expected   = "some text before <a href=\"http://example.com/\">an example</a> some text after"
    link_chunk = LinkChunk.new(input)

    result = link_chunk.render

    assert_equal expected, result
  end

  def test_removes_title_markdown_when_converts_markdown_link_to_http_attribute
    # skip
    input      = "(http://example.com/ \"Title\")"
    title_markdown = "\"Title\""
    expected   = "(http://example.com/)"

    link_chunk = LinkChunk.new(input)

    result = link_chunk.remove_title(input, title_markdown)

    assert_equal expected, result
  end

  def test_acceptance_with_title_attribute
    # skip
    input      = "some text before [an example](http://example.com/ \"Title\") some text after"
    expected   = "some text before <a href=\"http://example.com/\" title=\"Title\">an example</a> some text after"
    link_chunk = LinkChunk.new(input)

    result = link_chunk.render

    assert_equal expected, result
  end

  def test_acceptance_multiple_links
    # skip
    input      = "here is [example one](http://example.com/) and [example two](http://example.com/two/)"
    expected   = "here is <a href=\"http://example.com/\">example one</a> and <a href=\"http://example.com/two/\">example two</a>"
    link_chunk = LinkChunk.new(input)

    result = link_chunk.render

    assert_equal expected, result
  end

end
