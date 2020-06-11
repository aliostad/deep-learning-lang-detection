require File.dirname(__FILE__) + '/../../spec_helper'

describe EmailHandler::SpamHandler, "if given ham" do

  before do
    @email = Email.create(:raw => load_email(:to_jade))
    @handler = EmailHandler::SpamHandler.new(@email)
  end
  
  it "should not find recipient" do
    (!!@handler.found_recipient?).should == false
  end
  
  it "should not mark email as processed" do
    @handler.process    
    (!!@handler.processed?).should == false
  end

  it "should not mark email as handled" do
    @handler.process    
    (!!@handler.handled?).should == false
  end
  
end

describe EmailHandler::SpamHandler, "if given spam" do

  before do
    @email = Email.create(:raw => load_email(:spam))
    @handler = EmailHandler::SpamHandler.new(@email)
  end
  
  it "should not find recipient" do
    (!!@handler.found_recipient?).should == false
  end
  
  it "should mark email as processed" do
    @handler.process    
    (!!@handler.processed?).should == true
  end

  it "should mark email as handled" do
    @handler.process    
    (!!@handler.handled?).should == true
  end
  
end