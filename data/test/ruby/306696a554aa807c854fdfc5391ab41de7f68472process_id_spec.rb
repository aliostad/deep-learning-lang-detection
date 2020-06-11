require File.dirname(__FILE__) + '/../spec_helper'

describe ProcessId do
    
  def valid_process_id_attributes 
    {
      :value => 1,
      :usage_record => Factory.usage_record
    }
  end
    
  before(:each) do
    @process_id = ProcessId.new
  end
  
  it "should be valid with valid attributes" do
    @process_id.attributes = valid_process_id_attributes
    @process_id.should be_valid
  end
    
  it "should not be valid without a process id value" do
    @process_id.attributes  = valid_process_id_attributes.except( :value )
    @process_id.should_not be_valid
  end
  
  it "should not be valid with a non-numeric value" do
    @process_id.attributes  = valid_process_id_attributes.with( :value => 'foo' )
    @process_id.should_not be_valid
  end
  
  it "should not be valid with a non-positive integer" do
    @process_id.attributes  = valid_process_id_attributes.with( :value => -1 )
    @process_id.should_not be_valid
  end

  it "should not be valid with a non-integer number" do
    @process_id.attributes  = valid_process_id_attributes.with( :value => 1.075 )
    @process_id.should_not be_valid
  end

  it "should not be be valid without a usage record" do
    @process_id.attributes  = valid_process_id_attributes.except( :usage_record )
    @process_id.should_not be_valid
  end
  
end

describe ProcessId, ".get_all" do
    
  def array_of_process_ids
    [ 1, 2, 3, 4, 5 ]
  end
      
  before(:each) do
    @usage_record = Factory.usage_record
  end

  it "should return nil if the array is empty" do
    ProcessId.get_all( @usage_record, nil ).should be_nil
  end
  
  it "should not touch database if array is empty" do
    lambda { 
      process_ids = ProcessId.get_all( @usage_record, [] )
      @usage_record.process_ids = process_ids unless process_ids.nil?
    }.should_not change( ProcessId, :count )
  end
  
  it "should not touch database if array is nil" do
    lambda { 
      process_ids = ProcessId.get_all( @usage_record, nil )
      @usage_record.process_ids = process_ids unless process_ids.nil?
    }.should_not change( ProcessId, :count )
  end
  
  it "should not touch database without assigning to usage record" do
    lambda { 
      ProcessId.get_all( @usage_record, array_of_process_ids )
    }.should_not change( ProcessId, :count )
  end

  it "should increase the number of process ids for the usage record" do
    lambda { 
      @usage_record.process_ids = ProcessId.get_all( @usage_record, array_of_process_ids )
    }.should change( ProcessId, :count ).by( 5 )     
  end
  
  it "should increase the number of process ids for the usage record (alternate)" do
    lambda { 
      @usage_record.process_ids = ProcessId.get_all( @usage_record, array_of_process_ids )
    }.should change( @usage_record.process_ids, :count ).by( 5 )     
  end
        
end
