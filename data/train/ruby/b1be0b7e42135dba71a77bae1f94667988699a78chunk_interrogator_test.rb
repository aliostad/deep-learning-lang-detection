require 'test_helper'

class ChunkInterrogatorTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    # stub out Chunk##answer to see that it is called w/ correct attributes
    def Chunk.answer(slug, question, chunk_id=nil)
      [slug, question, chunk_id]
    end
    @model = ChunkInterrogator.new("nietzsche", "what is up?")
  end

  def teardown
    load "app/models/chunk.rb"
  end

  test "should respond to chunks" do 
    assert_respond_to @model, :chunks
  end

  test "#chunks should call Chunk##answer with correct params" do
    @model.chunk_id = 1
    assert_equal [@model.slug, @model.question, @model.chunk_id],
      @model.chunks
  end
end
