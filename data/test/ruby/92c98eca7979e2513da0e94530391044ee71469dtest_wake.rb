require 'test/test_helper'

class TestWake < Test::Unit::TestCase

  def setup
    Wake.options = nil
  end

  ## options

  test "debug option" do
    Wake.options.debug.should be(false)
    Wake.options.debug = true
    Wake.options.debug.should be(true)
  end

  ## functionality

  test "debug" do
    capture_io { Wake.debug('abc') }.stdout.should be('')
    Wake.options.debug = true
    capture_io { Wake.debug('abc') }.stdout.should be("[wake debug] abc\n")
  end

  test "picking handler" do

    Wake.handler = nil
    ENV['HANDLER'] = 'linux'
    Wake.handler.should be(HAVE_REV ? Wake::EventHandler::Rev : Wake::EventHandler::Portable)

    Wake.handler = nil
    ENV['HANDLER'] = 'bsd'
    Wake.handler.should be(HAVE_REV ? Wake::EventHandler::Rev : Wake::EventHandler::Portable)

    Wake.handler = nil
    ENV['HANDLER'] = 'darwin'
    Wake.handler.should be(HAVE_REV ? Wake::EventHandler::Rev : Wake::EventHandler::Portable)

    Wake.handler = nil
    ENV['HANDLER'] = 'unix'
    Wake.handler.should be(HAVE_REV ? Wake::EventHandler::Rev : Wake::EventHandler::Portable)

    Wake.handler = nil
    ENV['HANDLER'] = 'mswin'
    Wake.handler.should be(Wake::EventHandler::Portable)

    Wake.handler = nil
    ENV['HANDLER'] = 'cygwin'
    Wake.handler.should be(Wake::EventHandler::Portable)

    Wake.handler = nil
    ENV['HANDLER'] = 'portable'
    Wake.handler.should be(Wake::EventHandler::Portable)

    Wake.handler = nil
    ENV['HANDLER'] = 'other'
    Wake.handler.should be(Wake::EventHandler::Portable)
  end
end

