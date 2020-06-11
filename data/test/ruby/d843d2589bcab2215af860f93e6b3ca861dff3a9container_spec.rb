require_relative '../t.rb' 

describe Container do
  let(:handler) { Container.new }

  it "can create new tasks" do
    handler.create_task "Example Task", :normal
    handler.create_task "Another Task!", :low
    handler.create_task "NEED MORE TASKS!"
    handler.tasks.length.should == 3
  end

  it "can read individual tasks" do
    handler.create_task "Example Task"
    handler.create_task "Another Task"
    handler.read_task(0).should == "Example Task"
    handler.read_task(1).should == "Another Task"
  end

  it "can delete it's tasks" do
    handler.create_task "Example Task"
    handler.create_task "Another Task!"
    handler.delete_task!(0)
    handler.tasks[0].message.should == "Another Task!"
    handler.delete_task!(0)
    handler.tasks.length.should == 0
  end

  it "can re-prioritize individual tasks" do
    handler.create_task "Example Task"
    handler.tasks[0].priority.should == :normal
    handler.reprioritize!(0, :high)
    handler.tasks[0].priority.should == :high
  end
end
