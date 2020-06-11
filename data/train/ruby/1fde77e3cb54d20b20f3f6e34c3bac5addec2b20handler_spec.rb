require 'spec_helper'
require 'horizon/handler'

describe Horizon::Handler do
  class MyHandler
    include Horizon::Handler

    def my_event; end
    handler :my_event
  end

  describe '.handler' do
    it 'adds handlers' do
      MyHandler.events_handled.should == [:my_event]
      MyHandler.new.events_handled.should == [:my_event]
    end
  end

  describe '#handle' do
    it 'calls handler for event' do
      handler = MyHandler.new

      handler.stub(:my_event)
      handler.handle(:my_event, 4)

      handler.should have_received(:my_event).with(4)
    end
  end
end
