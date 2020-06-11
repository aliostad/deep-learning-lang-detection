require 'test_helper'

class ProcessTrunkTest < ActiveSupport::TestCase

  def setup
    @process_trunk = ProcessTrunk.new(valid_process_trunk_attributes)
  end

  def test_should_create_process_trunk
    assert @process_trunk.save, "Could not save this process_trunk"
  end

  def test_should_require_trunk_id
    process_trunk = ProcessTrunk.new(
            valid_process_trunk_attributes(:trunk_id => nil))
    assert !process_trunk.save
  end

  def test_trunk_should_be_instance_of_Trunk
    assert_instance_of Trunk, @process_trunk.trunk
  end

  def test_should_return_traceable_id_of_trunk
    assert_equal "87654321", @process_trunk.trunk.traceable
  end

end
