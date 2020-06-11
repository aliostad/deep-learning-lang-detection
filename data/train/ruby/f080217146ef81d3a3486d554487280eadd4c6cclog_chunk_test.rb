require 'test_helper'

class LogChunkTest < ActiveSupport::TestCase
  def test_create
    LogChunk.delete_all
    assert_equal 0, LogChunk.count

    stage = create_new_stage
    host = create_new_host
    role = create_new_role(:stage => stage, :host => host, :name => 'web')
    deployment = create_new_deployment(:stage => stage, :task => 'deploy')

    assert_nothing_raised{
      @chunk = deployment.log_chunks.new(:content => 'foo')
      @chunk.save!
    }

    assert_equal 'foo', @chunk.content
    assert_equal deployment.id, @chunk.deployment_id
    assert_equal 1, LogChunk.count
  end
end
