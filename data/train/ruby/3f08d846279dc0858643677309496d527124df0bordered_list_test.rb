gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require '../lib/ordered_list'

class OrderedListTest < Minitest::Test

  def test_it_exists
    chunk = "Hi"
    ord = OrderedList.new(chunk)
    assert ord, ord
  end

  def test_can_split_chunk
    chunk = "1. Sush
2. Barbeque
3. Mexican"
    ord = OrderedList.new(chunk)
    result = ord.splitter
    assert result.is_a?(Array)
  end

  def test_it_converts_numbers_to_li
    chunk = "1. Sushi
2. Barbeque
3. Mexican"
    ord = OrderedList.new(chunk)
    result = ord.list_maker
    assert_equal "<li>Sushi</li>\n", result[0]
    assert_equal "<li>Barbeque</li>\n", result[1]
    assert_equal "<li>Mexican</li>\n", result[2]
  end

  def test_it_adds_wrapper
    chunk = "1. Sushi
2. Barbeque
3. Mexican"
    ord = OrderedList.new(chunk)
    result = ord.add_wrapper
    assert_equal "<ol>
<li>Sushi</li>
<li>Barbeque</li>
<li>Mexican</li>
</ol>

", result
  end

  def test_it_does_everything
    chunk = "1. Sushi
2. Barbeque
3. Mexican"
    ord = OrderedList.new(chunk)
    result = ord.process
    assert_equal "<ol>
<li>Sushi</li>
<li>Barbeque</li>
<li>Mexican</li>
</ol>

", result
  end
end
