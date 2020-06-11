require File.dirname(__FILE__) + '/../spec_helper'

describe DeployProcess do
  before(:each) do
    @environment = create_environment()
    @deploy = create_deploy( :environment => @environment )
    @deploy_process = create_deploy_process( :environment_id => @environment.id, :deploy_id => @deploy.id )
  end

  it "should be valid" do
      @deploy_process.environment_id = 1
      @deploy_process.deploy_id = 1
      @deploy_process.should be_valid
  end
  
  it "should save" do
      @deploy_process.environment_id = 1
      @deploy_process.deploy_id = 1
      @deploy_process.save().should be_true
  end
end
