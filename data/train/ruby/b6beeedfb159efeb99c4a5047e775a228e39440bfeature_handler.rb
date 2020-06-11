require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe FeatureRich::FeatureHandler do
  it "should define a instance attribute reader :name" do
    @group.should respond_to(:name)
    @group.name.should be_an_instance_of(Symbol)
  end


  it "should respond to #new with a name" do
    FeatureRich::GroupFeature.should respond_to(:new).with(1)
  end

  it "should be labeled" do
    lambda do
      @handler = FeatureRich::FeatureHandler.new(:a_handler, :label => "This handler")
    end.should_not raise_exception
    @handler.should respond_to(:label)

    @handler.label.should == 'This handler'
    @handler.should respond_to(:label=)

    @handler.label = 'Other handler'
    @handler.label.should == 'Other handler'
  end

  it "should be disabled" do
    handler = FeatureRich::GroupFeature.new(:a_handler, :disabled => true)
    handler.disabled?.should be_true

    handler = FeatureRich::GroupFeature.new(:a_handler, :disabled => false)
    handler.disabled?.should be_false

    handler.disabled = true
    handler.disabled?.should be_true
  end

end
