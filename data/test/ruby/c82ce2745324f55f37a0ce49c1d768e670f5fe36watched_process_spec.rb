require 'satan'
require 'satan_mocks'

describe WatchedProcess do

  before(:each) do
    @process = WatchedProcess.new('simpleapp')
  end


  it "should get initialized" do
    @process.fmri.should == "simpleapp"
    @process.rules == []
  end


  it "should extract the pid for single process service" do
    @process.pid.should == 323
  end


  it "should extract the pid for multiprocess service based on daemon" do
    process = WatchedProcess.new(:webserver)
    process.daemon = 'wserver'
    process.pid.should == 453
  end

  
  it "should extract the pid for multiprocess service based on daemon and user" do
    process = WatchedProcess.new(:webserver)
    process.daemon = 'wserver'
    process.user = 'webservd'
    process.pid.should == 454
  end


  it "should extract the pid for multiprocess service based on daemon and args" do
    process = WatchedProcess.new(:webserver)
    process.daemon = 'wserver'
    process.args = 'https-foo'
    process.pid.should == 453
  end


  it "should extract the pid for multiprocess service based on daemon and user and args" do
    process = WatchedProcess.new(:webserver)
    process.daemon = 'wserver'
    process.user = 'webservd'
    process.args = 'https-foo'
    process.pid.should == 454
  end
end