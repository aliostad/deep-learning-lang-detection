gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require '../lib/unorderedlist'

class UnorderedListTest < Minitest::Test

  def test_it_exists
    chunk = "Hi"
    unord = UnorderedList.new(chunk)
    assert unord, unord
  end

  def test_can_split_chunk
    chunk = "* Sush
* Barbeque
* Mexican"
    unord = UnorderedList.new(chunk)
    result = unord.splitter
    assert result.is_a?(Array)
  end

  def test_it_converts_stars_to_li
    chunk = "* Sushi
* Barbeque
* Mexican"
    unord = UnorderedList.new(chunk)
    result = unord.list_maker
    assert_equal "<li>Sushi</li>\n", result[0]
    assert_equal "<li>Barbeque</li>\n", result[1]
    assert_equal "<li>Mexican</li>\n", result[2]
  end

  def test_it_adds_wrapper
    chunk = "* Sushi
* Barbeque
* Mexican"
    unord = UnorderedList.new(chunk)
    result = unord.add_wrapper
    assert_equal "<ul>
<li>Sushi</li>
<li>Barbeque</li>
<li>Mexican</li>
</ul>

", result
  end

  def test_it_does_everything
    chunk = "* Sushi
* Barbeque
* Mexican"
    unord = UnorderedList.new(chunk)
    result = unord.process
    assert_equal "<ul>
<li>Sushi</li>
<li>Barbeque</li>
<li>Mexican</li>
</ul>

", result
  end
end
