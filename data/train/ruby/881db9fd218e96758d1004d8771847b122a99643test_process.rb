require 'helper'

class ProcessTest < Test::Unit::TestCase

  context "Process.pql()" do

    should "raise an exception when given an invalid backend" do
      assert_raise NameError do
        Process.pql('NonExisting')
      end
    end

  end

  context "Process.find()" do

    should "find a process with pid 1" do
      query = Process.find(1)
      assert_equal query[:pid], 1
    end

    should "find a process with multiple pids" do
      query = Process.find(1, Process.pid)
      assert_equal query.length, 2
      assert_equal query[1][:pid], Process.pid
    end

  end

  context "Process.where()" do

    should "find a process with pid 1" do
      query = Process.where(:pid => 1)
      assert_equal query.count, 1
      assert_equal query.all.first[:pid], 1
    end

    should "find a process with our own pid" do
      query = Process.where(:pid => Process.pid)
      assert_equal query.count, 1
      assert_equal query.all.first[:pid], Process.pid
    end

    should "find a process with command = /ruby/" do
      query = Process.where(:command => Regexp.new(/ruby/))
      assert query.count >= 1
    end

    should "find a process with more than 0 bytes rss" do
      query = Process.where(:rss.gt => 0)
      assert query.count > 0
    end

  end

  context "Process.remove()" do

    should "remove it's own child" do
      ret = fork do
        sleep 10
      end

      query = Process.where(:pid => ret)
      assert_equal query.count, 1

      query.each do |process|
        Process.kill("QUIT", process[:pid])
      end
      Process.wait

      query = Process.where(:pid => ret)
      assert_equal query.count, 0
    end

  end

  context "Process.count()" do

    should "find a process with pid 1" do
      query = Process.find(1)
      assert_equal query[:pid], 1
    end

    should "find a process with multiple pids" do
      query = Process.find(1, Process.pid)
      assert_equal query.length, 2
      assert_equal query[1][:pid], Process.pid
    end

  end

end
