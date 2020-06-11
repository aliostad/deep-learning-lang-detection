require 'adsl/prover/util'

class ADSL::Prover::Util::GeneralTest < ActiveSupport::TestCase
  include ADSL::Prover
  
  def test_process_race__1_process
    stdout, process_index = Util.process_race "echo 'blah'"
    assert_equal 0, process_index
    assert_equal 'blah', stdout.strip
  end
  
  def test_process_race__2_processes
    time = Time.now
    stdout, process_index = Util.process_race "echo 'blah'", "sleep 20; echo 'blah2'"
    assert (Time.now - time) < 1
    assert_equal 0, process_index
    assert_equal 'blah', stdout.strip
  end

end
