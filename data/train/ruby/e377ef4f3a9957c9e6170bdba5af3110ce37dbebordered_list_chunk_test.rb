require 'minitest/autorun'
require 'minitest/pride'
require './lib/ordered_list_chunk'

class OrderedListChunkTest < Minitest::Test

  def test_does_not_detect_ordered_list_markdown
    input    = '*some* text'
    ol_chunk = OrderedListChunk.new(input)

    refute ol_chunk.contains_ordered_list_markdown?(input)
  end

  def test_detects_ordered_list_markdown
    input    = '1. some text'
    ol_chunk = OrderedListChunk.new(input)

    assert ol_chunk.contains_ordered_list_markdown?(input)
  end

  def test_surronds_one_markdown_list_item_with_li
    input    = '1. list value'
    expected = "<li>list value</li>\n"
    ol_chunk = OrderedListChunk.new(input)

    assert_equal expected, ol_chunk.add_list_html(input)
  end

  def test_surrounds_two_markdown_list_items_with_li
    input = <<-ordered_list_input
1. list item 1
2. list item 2
    ordered_list_input
    expected = <<-ordered_list_output
<li>list item 1</li>
<li>list item 2</li>
    ordered_list_output

    ol_chunk = OrderedListChunk.new(input)

    assert_equal expected, ol_chunk.add_list_html(input)
  end

  def test_surronds_list_with_ol_tags
    # skip
    input    = '1. list value'
    expected = <<-ordered_list_output
<ol>
  <li>list value</li>
</ol>

    ordered_list_output
    
    ol_chunk = OrderedListChunk.new(input)

    assert_equal expected, ol_chunk.render
  end

  def test_acceptance
    # skip
    input = <<-ordered_list_input
1. Sushi
2. Barbeque
3. Mexican
    ordered_list_input
    expected = <<-ordered_list_output
<ol>
  <li>Sushi</li>
<li>Barbeque</li>
<li>Mexican</li>
</ol>

    ordered_list_output

    ol_chunk = OrderedListChunk.new(input)

    assert_equal expected, ol_chunk.render
  end

end
