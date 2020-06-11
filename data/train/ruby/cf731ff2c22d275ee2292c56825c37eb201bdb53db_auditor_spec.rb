require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

describe "RulesEngine::Process::ReProcessAudit" do
  before(:each) do
    RulesEngine::Process.auditor = :db_auditor
    
    @now = Time.now
    @re_process_audit_1 = RulesEngine::Process::ReProcessAudit.create(:process_id => 1001, 
                                                                         :created_at => @now,
                                                                         :code => RulesEngine::Process::AUDIT_INFO,
                                                                         :message => "message 1")
    
    @re_process_audit_2 = RulesEngine::Process::ReProcessAudit.create(:process_id => 1001, 
                                                                         :created_at => @now + 1.minute,
                                                                         :code => RulesEngine::Process::AUDIT_INFO,
                                                                         :message => "message 2")
                                                                         
    @re_process_audit_3 = RulesEngine::Process::ReProcessAudit.create(:process_id => 1001, 
                                                                         :created_at => @now + 2.minute,
                                                                         :code => RulesEngine::Process::AUDIT_INFO,
                                                                         :message => "message 3")

    @re_process_audit_4 = RulesEngine::Process::ReProcessAudit.create(:process_id => 1002, 
                                                                         :created_at => @now,
                                                                         :code => RulesEngine::Process::AUDIT_INFO,
                                                                         :message => "message 4")
                                                 
  end
  
  describe "history" do
    describe "no plan code set" do
      it "should get all the active proceses in start date order" do
        RulesEngine::Process::ReProcessAudit.history(1001).should == [@re_process_audit_1, @re_process_audit_2, @re_process_audit_3]
      end

      # it "should use pagination" do
      #   RulesEngine::Process::ReProcessAudit.should_receive(:paginate).with(hash_including(:page => 1, :per_page => 10))
      #   RulesEngine::Process::ReProcessAudit.history(1001)
      # end
      # 
      # it "should use set pagination" do
      #   RulesEngine::Process::ReProcessAudit.should_receive(:paginate).with(hash_including(:page => 2, :per_page => 999))
      #   RulesEngine::Process::ReProcessAudit.history(1001, {:page => 2, :per_page => 999})
      # end
    end
  end
end

describe "RulesEngine::Process::DbAuditor" do
  before(:each) do
    RulesEngine::Process.auditor = :db_auditor
    
    @now = Time.now
    Time.stub!(:now).and_return(@now)
    
    @re_process_audit = mock_model(RulesEngine::Process::ReProcessAudit)
    @re_process_audit.stub!(:process_id).and_return(1001)
    @re_process_audit.stub!(:created_at).and_return(@now)
    @re_process_audit.stub!(:code).and_return(RulesEngine::Process::AUDIT_INFO)
    @re_process_audit.stub!(:message).and_return('mock message')

    page_data = [@re_process_audit, @re_process_audit]
    # page_data.stub!(:next_page => "103")
    # page_data.stub!(:previous_page => "101")
    
    RulesEngine::Process::ReProcessAudit.stub!(:create).and_return(@re_process_audit)
    RulesEngine::Process::ReProcessAudit.stub!(:history).and_return(page_data)    
  end
  
  describe "setting the auditor" do
    it "should set the auditor to the database process auditor" do
      RulesEngine::Process.auditor.should be_instance_of(RulesEngine::Process::DbAuditor)
    end
  end
  
  describe "auditting a message" do
    it "should create a new audit message" do
      RulesEngine::Process::ReProcessAudit.should_receive(:create).with(hash_including(:process_id => 2002, 
                                                                                        :created_at => @now.utc, 
                                                                                        :message => "audit message", 
                                                                                        :code => RulesEngine::Process::AUDIT_FAILURE))
      RulesEngine::Process.auditor.audit(2002, "audit message", RulesEngine::Process::AUDIT_FAILURE)
    end
  end      

  describe "getting the process audit history" do
    it "should returns a hash of the process data " do
      data = RulesEngine::Process.auditor.history(1001)
      data.should be_instance_of(Hash)
    end
    
    it "should include an array of audits" do
      data = RulesEngine::Process.auditor.history(1001)
      audits = data["audits"]
      audits.should be_instance_of(Array)
    end  
    
    it "should include the audit information" do
      data = RulesEngine::Process.auditor.history(1001)
      audits = data["audits"]
      
      audits.length.should == 2
      audits[0]["process_id"].should == 1001
      audits[0]["created_at"].should == @now.utc.to_s
      audits[0]["code"].should == RulesEngine::Process::AUDIT_INFO
      audits[0]["message"].should == "mock message"
  
      audits[1]["process_id"].should == 1001
      audits[1]["created_at"].should == @now.utc.to_s
      audits[1]["code"].should == RulesEngine::Process::AUDIT_INFO
      audits[1]["message"].should == "mock message"
    end
  end
    
end
