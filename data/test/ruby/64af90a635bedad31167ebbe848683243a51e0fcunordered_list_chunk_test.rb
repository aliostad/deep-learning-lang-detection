require 'minitest/autorun'
require 'minitest/pride'
require './lib/unordered_list_chunk'


class UnorderedListChunkTest < Minitest::Test

  def test_does_not_detect_unordered_list_markdown
    input    = 'some text'
    ul_chunk = UnorderedListChunk.new(input)

    refute ul_chunk.contains_unordered_list_markdown?(input)
  end


  def test_does_detect_unordered_list_markdown
    input    = '* list value'
    ul_chunk = UnorderedListChunk.new(input)

    assert ul_chunk.contains_unordered_list_markdown?(input)
  end

  def test_surrounds_one_markdown_list_item_with_li
    input = '* list value'
    expected = "<li>list value</li>\n"
    ul_chunk = UnorderedListChunk.new(input)

    assert_equal expected, ul_chunk.add_list_html(input)
  end

  def test_surrounds_two_markdown_list_items_with_li
    input = <<-unordered_list_input
* list item 1
* list item 2
    unordered_list_input
    expected = <<-unordered_list_output
<li>list item 1</li>
<li>list item 2</li>
    unordered_list_output
    ul_chunk = UnorderedListChunk.new(input)

    assert_equal expected, ul_chunk.add_list_html(input)
  end

  def test_surronds_list_with_ul_tags
    # skip
    input    = '* list value'
    expected = <<-unordered_list_output
<ul>
  <li>list value</li>
</ul>

    unordered_list_output
    ul_chunk = UnorderedListChunk.new(input)

    assert_equal expected, ul_chunk.render
  end

  def test_adds_newlines_to_end
    # skip
    input    = '* list value'
    expected = <<-unordered_list_output
<ul>
  <li>list value</li>
</ul>

    unordered_list_output
    ul_chunk = UnorderedListChunk.new(input)

    assert_equal expected, ul_chunk.render
  end

  def test_indents_list_items
    # skip
    input    = '* list value'
    expected = <<-unordered_list_output
<ul>
  <li>list value</li>
</ul>

    unordered_list_output
    ul_chunk = UnorderedListChunk.new(input)

    assert_equal expected, ul_chunk.render
  end

  def test_surrounds_single_list_item_with_li_tag
    # skip
    input    = '* list value'
    expected = <<-unordered_list_output
<ul>
  <li>list value</li>
</ul>

    unordered_list_output
    ul_chunk = UnorderedListChunk.new(input)

    assert_equal expected, ul_chunk.render
  end

  def test_surrounds_mutiple_list_items_with_li_tags
    # skip
    input = <<-unordered_list_input
* list item 1
* list item 2
    unordered_list_input
    expected = <<-unordered_list_output
<ul>
  <li>list item 1</li>
<li>list item 2</li>
</ul>

    unordered_list_output
    ul_chunk = UnorderedListChunk.new(input)

    assert_equal expected, ul_chunk.render
  end

  def test_acceptance
    # skip
    input = <<-unordered_list_input
* Sushi
* Barbeque
* Mexican
    unordered_list_input
    expected = <<-unordered_list_output
<ul>
  <li>Sushi</li>
<li>Barbeque</li>
<li>Mexican</li>
</ul>

    unordered_list_output
    ul_chunk = UnorderedListChunk.new(input)

    assert_equal expected, ul_chunk.render
  end
end
