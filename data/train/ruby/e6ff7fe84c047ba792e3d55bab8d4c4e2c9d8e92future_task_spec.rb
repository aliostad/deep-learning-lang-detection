require "spec_helper"

describe ActsAsExecutor::Common::FutureTask do
  before(:each) { @model = ActsAsExecutor::Common::FutureTask.new Executable.make, nil }

  it { @model.should be_a Java::java.util.concurrent.FutureTask }

  describe "#done" do
    context "when done handler exists" do
      it "should invoke handler" do
        handler = double "Handler"
        handler.stub :done_handler
        @model.done_handler = handler.method :done_handler

        handler.should_receive :done_handler

        @model.done
      end
    end
  end
end