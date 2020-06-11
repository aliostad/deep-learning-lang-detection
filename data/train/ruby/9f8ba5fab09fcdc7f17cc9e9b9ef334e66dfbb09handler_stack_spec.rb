require 'spec_helper'
require 'sax_stream/internal/handler_stack'

module SaxStream
  describe Internal::HandlerStack do
    let(:root)    { double("root handler") }
    let(:subject) { Internal::HandlerStack.new }
    let(:handler) { double("another handler") }

    before do
      subject.root = root
    end

    it "starts with the root handler as top" do
      subject.top.should == root
    end

    it "can push a new handler onto the top" do
      subject.push(handler)
      subject.top.should == handler
    end

    it "can pop a handler and it is no longer top" do
      subject.push(handler)
      subject.pop
      subject.top.should == root
    end

    it "raises an error if it attempts to pop the root handler" do
      lambda {
        subject.pop
      }.should raise_error
    end
  end
end