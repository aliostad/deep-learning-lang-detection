require 'helper'

class TestWorker < Test::Unit::TestCase

  context "worker" do
    setup do
      @queue = java.util.concurrent.ArrayBlockingQueue.new(20)
    end

    should "stop when taking stop symbol from queue" do
      handler = mock("handler")
      handler.expects(:handle).times(10)
      handler.expects(:respond_to?).with(:cleanup).returns(true)
      handler.expects(:cleanup).once
      handler_class = mock("handler_class")
      handler_class.expects(:new).returns(handler)

      10.times { |i| @queue.put("aa 127.0.0.1 #{i} /k/call/") }
      @queue.put(:stop)
      worker = Kafkaesque::Worker.new(@queue, :handler => handler_class)
      worker.do_work
    end

    should "create event and call handler" do
      event = mock(event)
      Kafkaesque::Event.expects(:new).with("aa 127.0.0.1 123 /k/call/").returns(event)
      handler = mock("handler")
      handler.expects(:handle).with(event)
      handler_class = mock("handler_class")
      handler_class.expects(:new).returns(handler)

      @queue.put("aa 127.0.0.1 123 /k/call/")
      @queue.put(:stop)
      worker = Kafkaesque::Worker.new(@queue, :handler => handler_class)
      worker.do_work
    end

    should "rescue exceptions thrown by handler" do
      handler = mock("handler")
      handler.expects(:handle).raises(StandardError, 'test')
      handler_class = mock("handler_class")
      handler_class.expects(:new).returns(handler)

      1.times { |i| @queue.put("aa 127.0.0.1 #{i} /k/call/") }
      @queue.put(:stop)
      worker = Kafkaesque::Worker.new(@queue, :handler => handler_class)
      _, stdout, _ = silence_is_golden do
        assert_nothing_raised do
          worker.do_work
        end
      end

      assert_match /StandardError: test/, stdout
    end

  end

end

