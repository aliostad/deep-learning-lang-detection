require 'spec_helper'

describe VCAP::Micro::MonitoredProcess do

  describe '#stop' do

    it 'stops the process' do
      VCAP::Micro.should_receive(:shell_raiser).with('monit stop process')
      VCAP::Micro::MonitoredProcess.new('process').stop
    end

  end

  describe '#running' do
    context 'running' do
      it 'is running' do
        VCAP::Micro::MonitoredProcess.new('process').running?(
          'process' => { :status => { :message => 'running' } }
          ).should be_true
      end
    end

    context 'not running' do
      it 'is not running' do
        VCAP::Micro::MonitoredProcess.new('process').running?(
          'process' => { :status => { :message => 'not running' } }
          ).should be_false
      end

      it 'is incomplete (i.e. the service is not monitored by monit properly)' do
        VCAP::Micro::MonitoredProcess.new('process').running?('foo' => {}).should be_false
        VCAP::Micro::MonitoredProcess.new('process').running?('process' => nil).should be_false
        VCAP::Micro::MonitoredProcess.new('process').running?('process' => {:status => nil}).should be_false
        VCAP::Micro::MonitoredProcess.new('process').running?('process' => {:status => {:message => nil}}).should be_false
      end
    end
  end
end
