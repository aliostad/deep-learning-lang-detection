require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Fastest
  describe GenericProcess do
    def fake_process(name = nil, args = {})
      @fake_processes ||= {}
      @real_processes ||= {}
      return @fake_processes.values if name.nil?
      unless @fake_processes.has_key? name
        fake = Factory(:fake_process, {:name => name.to_s}.merge(args))
        real = Process.new(fake.pid, fake.created_at, fake.ppid, fake.name, fake.path, fake.cmd_line)
        @real_processes[name] = real
        @fake_processes[name] = fake
      else
        @fake_processes[name]
      end
    end

    def real_process(name = nil, args = {})
      fake = fake_process(name, args)
      if name.nil?
        @real_processes.values.shuffle
      else
        @real_processes[name]
      end
    end

    before(:each) do
      # processes are created with increasing pid and created_at unless specified otherwise
      fake_process(:init)
      fake_process(:kthreadd)
      fake_process(:sshd, :ppid => fake_process(:init).pid)
      fake_process(:bash, :ppid => fake_process(:init).pid)
      fake_process(:chrome, :ppid => fake_process(:bash).pid)
      fake_process(:ruby, :ppid => fake_process(:bash).pid)
      fake_process(:dead, :ppid => fake_process(:bash).pid)
      fake_process(:parent_reused, :created_at => fake_process(:bash).created_at - 1, :ppid => fake_process(:bash).pid)
      fake_process(:parent_dead, :ppid => fake_process(:dead).pid)

      # stub process running states
      [:init, :kthreadd, :sshd, :bash, :chrome, :ruby, :parent_reused, :parent_dead].each do |name|
        real_process(name).stub(:state) do
          {:running => true}
        end
      end
      real_process(:dead).stub(:state) do
        {:running => false}
      end

      # stub the process table
      Sys::ProcTable.stub(:ps) do |pid|
        unless pid.nil?
          fake_process.find do |process|
            process.pid == pid
          end
        else
          fake_process
        end
      end
      Process.stub(:sys_process_to_process) do |process|
        process.should be_kind_of FakeProcess
        real_process(process.name.to_sym)
      end
      # return ruby as the current process
      ::Process.stub(:pid).and_return(fake_process(:ruby).pid)
      ::Process.stub(:ppid).and_return(fake_process(:ruby).ppid)
    end

    describe '#<=>' do
      it 'should only sort by PID and creation time' do
        process1 = real_process(:ls)
        process2 = real_process(:cat, :pid => process1.pid, :created_at => process1.created_at)
        process1.should == process2
        process2.should == process1
      end

      it 'should sort by PID (in ascending order)' do
        process1 = real_process(:ls)
        process2 = real_process(:cat, :created_at => process1.created_at)
        process1.should < process2
        process2.should > process1
      end

      it 'should sort by creation time (in ascending order)' do
        process1 = real_process(:ls, :created_at => Time.at(2))
        process2 = real_process(:cat, :pid => process1.pid, :created_at => Time.at(1))
        process1.should > process2
        process2.should < process1
      end

      it 'should first sort by PID' do
        process1 = real_process(:ls, :created_at => Time.at(2))
        process2 = real_process(:cat, :created_at => Time.at(1))
        process1.should < process2
        process2.should > process1
      end
    end

    describe '#parent' do
      it 'should return the parent if it still exists' do
        real_process(:sshd).parent.should == real_process(:init)
        real_process(:bash).parent.should == real_process(:init)
        real_process(:chrome).parent.should == real_process(:bash)
        real_process(:ruby).parent.should == real_process(:bash)
        real_process(:dead).parent.should == real_process(:bash)
        real_process(:parent_dead).parent.should == real_process(:dead)
      end

      it 'should return nil if the parent does not exist' do
        real_process(:init).parent.should be_nil
        real_process(:kthreadd).parent.should be_nil
      end

      it 'should return nil for orphan objects whose parent ID is being reused' do
        real_process(:parent_reused).parent.should be_nil
      end

      it 'should cache the parent process (even if nil)' do
        Process.should_receive(:by_pid).with(real_process(:parent_reused).ppid).exactly(1).times
        real_process(:parent_reused).parent.should be_nil
        Process.rspec_verify
        Process.should_not_receive(:by_pid)
        real_process(:parent_reused).parent.should be_nil
      end
    end

    describe '#running?' do
      it 'should be true if the process is still running' do
        [:init, :kthreadd, :sshd, :bash, :chrome, :ruby, :parent_reused, :parent_dead].each do |name|
          real_process(name).should be_running
        end
      end

      it 'should be false if the process has finished running' do
        real_process(:dead).should_not be_running
      end
    end

    describe '#orphan?' do
      it 'should be true if parent does not exist' do
        real_process(:init).should be_orphan
        real_process(:kthreadd).should be_orphan
      end

      it 'should be true if a new process reusing the original parent ID exists' do
        real_process(:parent_reused).should be_orphan
      end

      it 'should be true if parent exists but has finished running' do
        real_process(:dead).should_receive(:state).and_return({:running => false})
        real_process(:parent_dead).should be_orphan
      end

      it 'should be false if parent exists and it is currently running' do
        [:dead, :sshd, :bash, :chrome, :ruby].each do |name|
          real_process(name).should_not be_orphan
        end
      end
    end

    it 'should behave like an enumerable' do
      [:any?, :include?, :inject, :map, :select].each do |method|
        Process.should respond_to method
      end
    end

    describe '.all' do
      subject do
        Process.all.sort
      end

      it 'should return an array of processes' do
        should be_kind_of Array
        subject.each do |process|
          process.should be_kind_of Process
        end
      end

      it 'should consist of all running processes' do
        should == real_process.sort
      end

      it 'should cache all parents' do
        Process.should_not_receive(:by_pid)
        subject.each do |process|
          process.parent
        end
      end
    end

    describe '.each' do
      subject do
        Process.each
      end

      it 'should be an enumerator' do
        subject.should be_kind_of Enumerator
      end

      it 'should contain processes' do
        subject do |process|
          process.should be_kind_of Process
        end
      end

      it 'should consist of all running processes' do
        subject.map.sort.should == real_process.sort
      end
    end

    describe '.by_pid' do
      it 'should return the process for the given PID' do
        real_process.each do |process|
          Process.by_pid(process.pid).should == process
        end
      end

      it 'should return nil for a non-existent PID' do
        Process.by_pid(9999).should be_nil
      end

      it 'should return nil if passed pid is nil' do
        Process.by_pid(nil).should be_nil
      end
    end

    describe '.current' do
      subject do
        Process.current
      end

      it 'should be ruby' do
        should == real_process(:ruby)
      end
    end
  end
end
