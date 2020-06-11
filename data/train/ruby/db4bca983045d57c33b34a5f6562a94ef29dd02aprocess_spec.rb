require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'ruby_is_forked/process'

describe "RubyIsForked::Process" do
  before(:each) do
    Process.current = nil
  end
    
  it "Process.current should return new objects in child." do
    Process.current.object_id.should == Process.current.object_id
    parent = Process.current
    parent.process_id.should == $$
    parent[:var] = $$
    parent[:var].should == $$

    child_pid = Process.fork do 
      child = Process.current
      child[:var].should == nil
      child.parent.should_not == nil
      child.parent.process_id.should == parent.process_id
      child.parent[:var].should == parent.process_id
      Process.exit!(0)
    end
    w = Process.waitpid2(child_pid)
    w[1].exitstatus.should == 0
    w[0].should == child_pid
    w[1].pid.should == child_pid
  end
end # unless

