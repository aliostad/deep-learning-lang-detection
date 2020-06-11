require 'pcccbhandler'
require 'minitest/autorun'

class TestItem < Minitest::Test
  def callback(success, error)
    @callback_error = error
    @callback_success = success
  end

  def setup
    @callback_success = nil
    @callback_error = nil
  end

  def test_initialize
    handler = PubControlClientCallbackHandler.new(1, method(:callback))
    assert_equal(handler.instance_variable_get(:@num_calls), 1)
    assert_equal(handler.instance_variable_get(:@success), true)
    assert_equal(handler.instance_variable_get(:@first_error_message), nil)
    assert_equal(handler.instance_variable_get(:@callback), method(:callback))
  end

  def test_handler_one_call_success
    handler = PubControlClientCallbackHandler.new(1, method(:callback))
    handler.handler(true, nil)
    assert(@callback_success)
    assert(@callback_error.nil?)
  end

  def test_handler_three_call_success
    handler = PubControlClientCallbackHandler.new(3, method(:callback))
    handler.handler(true, nil)
    assert(@callback_success.nil?)
    handler.handler(true, nil)
    assert(@callback_success.nil?)
    handler.handler(true, 'should not be there')
    assert(@callback_success)
    assert(@callback_error.nil?)
  end

  def test_handler_one_call_failure
    handler = PubControlClientCallbackHandler.new(1, method(:callback))
    handler.handler(false, 'failure')
    assert(@callback_success == false)
    assert(@callback_error == 'failure')
  end

  def test_handler_three_call_failure
    handler = PubControlClientCallbackHandler.new(3, method(:callback))
    handler.handler(false, 'failure')
    assert(@callback_success.nil?)
    assert(@callback_error.nil?)
    handler.handler(true, nil)
    assert(@callback_success.nil?)
    assert(@callback_error.nil?)
    handler.handler(false, 'failure2')
    assert(@callback_success == false)
    assert(@callback_error == 'failure')
  end

  def test_handler_method_symbol
    handler = PubControlClientCallbackHandler.new(1, method(:callback))
    handler.handler_method_symbol.call(true, nil)
    assert(@callback_success)
    assert(@callback_error.nil?)
  end
end
