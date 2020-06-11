require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "MethodHandler " do
  
  EVENT_PARAMETER = { :param => "some param"}
  
  class TestHandler
    def test_method_handler(source, parameters)
    end
  end
  
  before( :each ) do 
    @test_handler = TestHandler.new
    @handler = Eventorz::MethodHandler.new( @test_handler, :test_method_handler)
    @source = self
  end
  
  it "is built with a target and method" do
    @handler.should be_kind_of Eventorz::MethodHandler
  end
  
  it "is equal if it has the same target and method" do
    first = Eventorz::MethodHandler.new( @test_handler, :test_method_handler)
    second = Eventorz::MethodHandler.new( @test_handler, :test_method_handler)
    
    first.should == second 
  end
  
  it "invokes the method handler with source and parameters" do
    @test_handler.should_receive(:test_method_handler).with(@source, EVENT_PARAMETER)  
    
    @handler.fire @source, EVENT_PARAMETER
  end
  
  it "to_s shows class, target and method" do
    @handler.to_s.should =~ /Eventorz::MethodHandler:target=#<.*?>;method=test_method_handler/
  end
  
end
