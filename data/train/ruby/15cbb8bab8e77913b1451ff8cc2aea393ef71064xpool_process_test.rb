require_relative 'setup'
class XPoolProcessTest < Test::Unit::TestCase
  def setup
    @process = XPool::Process.new
  end

  def teardown
    @process.shutdown!
  end

  def test_busy_method
    @process.schedule Sleeper.new(0.5)
    sleep 0.1
    assert @process.busy?, 'Expected process to be busy'
    sleep 0.5
    refute @process.busy?, 'Expected process to not be busy'
  end

  def test_busy_on_exception
    @process.schedule Raiser.new
    sleep 0.1
    refute @process.busy?
  end

  def test_busy_method_on_dead_process
    @process.schedule Sleeper.new(1)
    @process.shutdown!
    refute @process.busy?
  end

  def test_frequency
    4.times { @process.schedule Sleeper.new(0.1) }
    assert_equal 4, @process.frequency
  end

  def test_queue
    writers = Array.new(5) { IOWriter.new }
    writers.each { |writer| @process.schedule writer }
    @process.shutdown
    writers.each { |writer| assert writer.wrote_to_disk? }
  end

  def test_failed_on_failed_process
    @process.schedule Raiser.new
    sleep 0.1
    assert @process.failed?
  end

  def test_restart_on_failed_process
    @process.schedule Raiser.new
    assert_instance_of Fixnum, @process.restart
  end

  def test_failed_process_is_also_dead
    @process.schedule Raiser.new
    sleep 0.1
    assert @process.dead?
  end

  def test_backtrace
    @process.schedule Raiser.new
    sleep 0.1
    assert_equal %w(42), @process.backtrace
  end

  def test_race_condition_in_process_forced_to_shutdown
    @process.schedule IOWriter.new
    sleep 0.5
    @process.shutdown!
    assert @process.dead?
  end

  def test_race_condition_in_process_shutdown_gracefully
    @process.schedule IOWriter.new
    sleep 0.5
    @process.shutdown
    assert @process.dead?
  end
end
