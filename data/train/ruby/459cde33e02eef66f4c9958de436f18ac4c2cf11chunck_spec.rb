require 'fantasynamegenerator.rb'

# simple chunk 
describe Chunk do
    
    before do
        @chunk = Chunk.new("test", "static content")
    end

    it "Should contain static content" do
        @chunk.render.should == "static content"
    end

end

# provider chunk 
describe Chunk do
    
    before do
        @chunk = Chunk.new("test", nil, Provider.new)
    end

    it "Should not contain static content" do
        @chunk.render.should_not == "static content"
    end
    
    it "Should echo path and name" do
        @chunk.render.should == "test"
    end

end

# children chunk 
describe Chunk do
    
    before do
        @chunk = Chunk.new("test")
        @chunk.add_child(Chunk.new("Child1", "1"))
        @chunk.add_child(Chunk.new("Child2", "2"))
        @chunk.add_child(Chunk.space)
        @chunk.add_child(Chunk.new("Child3", "3"))
    end

    it "Should not contain static content" do
        @chunk.render.should_not == "static content"
    end
    
    it "Should not echo path and name" do
        @chunk.render.should_not == "test"
    end
    
    it "Should contain child elements" do
        @chunk.render.should == "12 3"
    end
end

# children chunk with chance
describe Chunk do
    
    before do
        @chunk = Chunk.new("test")
        @chunk.add_child(Chunk.new("Child1", "1"), 0..50)
        @chunk.add_child(Chunk.new("Child2", "2"), 41..60)
        @chunk.add_child(Chunk.space, 41..60)
        @chunk.add_child(Chunk.new("Child3", "3"))
    end

    it "Should contain child elements based on chance" do
        @chunk.render(0).should == "13"
    end
    it "Should contain child elements based on chance" do
        @chunk.render(45).should == "12 3"
    end
    it "Should contain child elements based on chance" do
        @chunk.render(80).should == "3"
    end
end

# complex childen chunk 
describe Chunk do
    
    before do
        @chunk = Chunk.new("test")
        @chunk.add_child(Chunk.new("Child1", nil, Provider.new), 0..50)
        @chunk.add_child(Chunk.space)
        @chunk.add_child(Chunk.new("Child2", "1"))
        @chunk.add_child(Chunk.space)
        @childchunk1 = Chunk.new("Child3Child1", "2")
        @childchunk2 = Chunk.new("Child3Child2", nil, Provider.new)
        @child = Chunk.new("Child3")
        @chunk.add_child(@child)
        @child.add_child(@childchunk1)
        @child.add_child(@childchunk2)        
    end

    it "Should not contain static content" do
        @chunk.render.should_not == "static content"
    end
    
    it "Should not echo path and name" do
        @chunk.render.should_not == "test"
    end
    
    it "Should contain child elements and their children, some from providers" do
        @chunk.render.should == "test-Child1 1 2test-Child3-Child3Child2"
    end
end

# complex childen chunk, with the children added in different order
describe Chunk do
    
    before do
        @chunk = Chunk.new("test")
        @chunk.add_child(Chunk.new("Child1", nil, Provider.new))
        @chunk.add_child(Chunk.space)
        @chunk.add_child(Chunk.new("Child2", "1"))
        @chunk.add_child(Chunk.space)
        @childchunk1 = Chunk.new("Child3Child1", "2")
        @childchunk2 = Chunk.new("Child3Child2", nil, Provider.new)
        @child = Chunk.new("Child3")
        @child.add_child(@childchunk1)
        @child.add_child(@childchunk2)        
        @chunk.add_child(@child)        
    end

    it "Should not contain static content" do
        @chunk.render.should_not == "static content"
    end
    
    it "Should not echo path and name" do
        @chunk.render.should_not == "test"
    end
    
    it "Should contain child elements and their children, some from providers" do
        @chunk.render.should == "test-Child1 1 2test-Child3-Child3Child2"
    end
end