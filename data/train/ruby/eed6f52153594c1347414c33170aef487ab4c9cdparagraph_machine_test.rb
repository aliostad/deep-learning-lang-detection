require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/paragraph_machine'

class ParagraphMachineTest < Minitest::Test
  def test_it_sandwiches_text_with_p
    chunk = "You just have to try the cheesecake"
    result = ParagraphMachine.convert(chunk)
    assert_equal "<p>\nYou just have to try the cheesecake\n</p>", result
  end

  def test_it_can_handle_a_new_line_in_the_middle
    chunk = "You just have to try\n the cheesecake"
    result = ParagraphMachine.convert(chunk)
    assert_equal "<p>\nYou just have to try\n the cheesecake\n</p>", result
  end

  def test_it_can_handle_first_character_hash
    chunk = "# You just have to try the cheesecake"
    result = ParagraphMachine.convert(chunk)
    assert_equal chunk, result
  end

end