require 'helper'
require 'media/command/child_process'

module Media
  module Command
    class TestChildProcess < MiniTest::Unit::TestCase
      
      def subject
        ChildProcess
      end
      
      def test_stdout
        process = subject.new(command: ['echo', 'hello'])
        
        assert_equal("hello\n", process.call.out)
      end
      
      def test_stderr
        process = subject.new(command: ['ffprobe'])

        assert_match(/^ffprobe/, process.call.error)
      end
      
      def test_success
        process = subject.new(command: 'true')
        
        assert(process.call.success?)
      end
      
      def test_failure
        process = subject.new(command: 'false')
        
        refute(process.call.success?)
      end
      
      def test_streaming
        process = subject.new(command: ['echo', "hello\n", 'there'])
        
        out = ''
        process.call {|line| out << line}
        
        assert_equal("hello\n there", out)
      end
    end
  end
end