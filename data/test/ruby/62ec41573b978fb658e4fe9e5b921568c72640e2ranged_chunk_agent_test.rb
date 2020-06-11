require File.expand_path('../test_helper', File.dirname(__FILE__))

class TestRangedChunkAgent < Granite::BaseAgent
  def self.new_range(throwaway)
    (123..235)
  end
end

class TestRangedChunkAgentTwo
  def self.new_range(throwaway)
    (123..235)
  end
end

class TestNotRangedChunkAgent

end

class TestSyncronousChunkAgent
  def self.new_range(x)
    (0..9)
  end
  
  def process
    raise "please mock"
  end
  
end

module Granite
  class RangedChunkAgentTest < ActiveSupport::TestCase
    if Granite::Configuration.all_settings['enable_ranged_chunk_agents'] && Granite::Configuration.all_settings['enable_ranged_chunk_agents'] != 'false'

      def setup
        RangedChunkAgent.destroy_all
        @agent = RangedChunkAgent.create(
          :agent_class => 'TestRangedChunkAgent',
          :enabled => true,
          :chunk_size => 100,
          :interval => 0,
          :cursor => 1,
          :last_processed_timestamp => Time.now)
      end

      test "agents should not run if they are disabled" do
        @agent.update_attribute(:enabled, false)
        RangedChunkAgent.any_instance.expects(:run).never
        RangedChunkAgent.run_agents
      end

      test "agents should not run if they are within their interval window" do
        now = Time.now
        @agent.update_attribute(:enabled, true)
        @agent.update_attribute(:last_processed_timestamp, now)
        @agent.update_attribute(:interval, 1000)
        RangedChunkAgent.any_instance.expects(:run).never
        RangedChunkAgent.run_agents
      end
    
      test 'agents should run if they are enabled and past their interval window' do
        now = Time.now
        @agent.update_attribute(:enabled, true)
        @agent.update_attribute(:last_processed_timestamp, now - 1001.seconds)
        @agent.update_attribute(:interval, 1000)
        RangedChunkAgent.any_instance.expects(:run).once
        RangedChunkAgent.run_agents
      end
    
      test 'agents validate that there is a chunk size or number of chunks set' do
        @agent = RangedChunkAgent.new(:agent_class => 'TestRangedChunkAgent')
        assert_false @agent.valid?
        @agent.chunks = 1
        assert @agent.valid?
      end
   
      test 'agents publish based on routing key' do
        RangedChunkProducer.expects(:publish).with("123..223", {:key => 'TestRangedChunkAgent'}).once
        RangedChunkAgent.run_agents
      end
     
      test 'agents publish and keep cursor correctly based on chunk size' do
        @agent.update_attribute(:enabled, true)
        @agent.update_attribute(:interval, 0)
        @agent.update_attribute(:chunk_size, 56)
        RangedChunkProducer.expects(:publish).with("123..179", {:key => 'TestRangedChunkAgent'}).once
        RangedChunkProducer.expects(:publish).with("179..235", {:key => 'TestRangedChunkAgent'}).once
        RangedChunkAgent.run_agents
        assert_equal 235, @agent.reload.cursor
      end
    
      test 'agents publish and keep cursor correctly based on number of chunks' do
        @agent.update_attribute(:chunk_size, nil)
        @agent.update_attribute(:chunks, 2)
        RangedChunkProducer.expects(:publish).with("123..179", {:key => 'TestRangedChunkAgent'}).once
        RangedChunkProducer.expects(:publish).with("179..235", {:key => 'TestRangedChunkAgent'}).once
        RangedChunkAgent.run_agents
        assert_equal 235, @agent.reload.cursor
      end
    
      test 'agents that dont have "new_range" defined generate a nice message' do
        RangedChunkAgent.any_instance.expects(:should_run?).returns(true)
        @agent.update_attribute(:agent_class, 'TestNotRangedChunkAgent')
        RosettaStone::GenericExceptionNotifier.expects(:deliver_exception_notification).with do |exception|
          exception.is_a?(RangedChunkAgent::NotChunkableAgentError)
        end
        RangedChunkAgent.run_agents
      end
    
      test 'chunk_by_size doesnt unexpectedly return 0, but is at least the bottom of the range' do
        assert_equal 1, @agent.cursor
        new_cursor = @agent.chunk_by_size(100, (1..1)) {}
        assert_equal 1, new_cursor
      end
      
      test 'chunk_by_size deals with the range going backwards' do
        new_cursor = @agent.chunk_by_size(10, (100..50)) { 
          assert false # shouldn't execute this.
        }
        assert_equal 50, new_cursor
      end
      
      test 'lock stops you from running two agents at the same time' do
        RangedChunkProducer.stubs(:publish)
        @agent.expects(:per_chunk).once
        @agent.run do
          assert_true @agent.locked?
        end
      end
      
      # this is kinda artificial and weird.
      test 'an agent coming out of waiting for the lock checks the new cursor' do
        @smagent = RangedChunkAgent.first #different reference
        @smagent.run do
          assert_equal 1, @agent.cursor
      
          @agent.run do # this is using the same connection, so it has the lock, so we have to simulate
            TestRangedChunkAgent.expects(:new_range).with(1).returns((1..101))
            RangedChunkProducer.expects(:publish).with("1..101", {:key => 'TestRangedChunkAgent'}).once
          end
          assert_equal 1, @smagent.cursor
          TestRangedChunkAgent.expects(:new_range).with(101).returns((101..201))
          RangedChunkProducer.expects(:publish).with("101..201", {:key => 'TestRangedChunkAgent'}).once
        end
      end
      
      test 'a failure during chunking/publishing releases the lock properly' do
        assert_raises(Exception) do
          @agent.run do
            raise Exception.new("BOOM!")
          end
        end
        assert_false @agent.locked?
      end
      
      test 'a failing agent doesnt stop the processing of all agents but alerts hoptoad' do
        exception = Exception.new("eels")
        @agent2 = RangedChunkAgent.create(
          :agent_class => 'TestRangedChunkAgentTwo',
          :enabled => true,
          :chunk_size => 100,
          :interval => 0,
          :cursor => 1,
          :last_processed_timestamp => Time.now)
        RosettaStone::GenericExceptionNotifier.expects(:deliver_exception_notification).with(exception).twice
        RangedChunkAgent.any_instance.expects(:run).raises(exception).twice
        RangedChunkAgent.run_agents
      end
      
      test 'benchmarking of chunking' do
        # don't run this if the app hasn't run the migration
        RangedChunkProducer.stubs(:publish)
        @agent.run
        if @agent.respond_to?(:last_chunking_time)
          assert_not_nil @agent.last_chunking_time
          assert @agent.last_chunking_time >= 1
        end
      end
      
      test 'running non granite agents as ranged chunk processes immediately' do
        @agent = RangedChunkAgent.create(:agent_class => "TestSyncronousChunkAgent", :enabled => true, :chunks => 1, :interval => nil, :cursor=> 0, :last_processed_timestamp => Time.now)
        TestSyncronousChunkAgent.any_instance.expects(:process).with({}, "0..9")
        @agent.run
      end
      
      test 'running an agent that has no new records to run updates the last_processed_timestamp' do
        now = Time.now
        Time.stubs(:now).returns(now)
        @agent = RangedChunkAgent.create(:agent_class => "TestRangedChunkAgent", :enabled => true, :chunks => 1, :interval => nil, :cursor=> 0, :last_processed_timestamp => Time.now - 1.minute)
        TestRangedChunkAgent.expects(:new_range).with(0).returns((0..0))
        @agent.run
        assert_equal now, @agent.last_processed_timestamp
      end
      
    end  
  end
end
