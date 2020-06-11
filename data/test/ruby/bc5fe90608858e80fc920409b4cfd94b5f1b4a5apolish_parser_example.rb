shared_examples_for "polish parser" do
  def calculate(string)
    @parser.new.calculate(string)
  end

  it "Should support addition" do
    calculate("+ 1 2").should == 3
  end
  
  it "Should support recusive addition" do
    calculate("+ + 1 2 3").should == 6
    calculate("+ 1 + 2 3").should == 6
  end

  it "Should support multiple operator" do
    calculate("+ 1 * 4 5").should == 21
  end

  it "Should be permissive in syntax" do
    calculate(" +1*3-4 ").should == -11
  end

  it "should support negative number" do
    calculate("- -4 -8").should == 4
  end

  it "should support float" do
    calculate("/ 1 0.5").should == 2.0
  end

  it "Should support operation priority" do
    calculate("* - 2 1 1").should == 1
    calculate("+ 1 * 1 2").should == 3
  end

  it "Should support parenthesis" do
    calculate("* (+ 1 3) 2").should == 8
  end
end
