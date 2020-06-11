require 'test/unit'
require 'edifact_converter/empty_handler'

module EdifactConverter

  class EmptyHandlerTest < Test::Unit::TestCase

    class SimpleTest
      def answer
        42
      end
      def multiply(a, b)
        a*b
      end
      def blocks
        yield
      end
    end

    def test_forward_all
      handler = EmptyHandler.new SimpleTest.new
      assert_equal 42, handler.answer
      assert_equal 42, handler.multiply(7, 6)
      assert_equal 42, handler.blocks(){42}
    end

    def test_ignore_if_nil
      handler = EmptyHandler.new
      assert_nil handler.answer
    end

  end

end
