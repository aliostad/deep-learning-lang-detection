
require 'test/test_helper'

class TestChunk < ActiveSupport::TestCase
  setup do
    NFAgent::Config.config_file = "test/config"
    NFAgent::Config.init
    @logline = "1253604221  19 127.0.0.1 TCP_MISS/200 562 GET http://www.gravatar.com/blavatar/e81cfb9068d04d1cfd598533bb380e1f?s=16&d=http://s.wordpress.com/favicon.ico - NONE/- text/html"
  end

  test "initialize" do
    chunk = NFAgent::Chunk.new
    assert_equal 500, chunk.max_size
    chunk = NFAgent::Chunk.new(600)
    assert_equal 600, chunk.max_size
  end

  test "full" do
    chunk = NFAgent::Chunk.new(20)
    19.times do
      chunk << @logline
    end
    assert !chunk.full?
    chunk << @logline
    assert chunk.full?
    assert_raises(NFAgent::ChunkFull) { chunk << @logline }
  end

  test "won't expire if empty" do
    NFAgent::Config.chunk_time_out = 1
    chunk = NFAgent::Chunk.new
    assert !chunk.expired?
    Timecop.freeze(Time.now + 61) do
      assert !chunk.expired?
    end
  end

  test "expired" do
    chunk = NFAgent::Chunk.new
    chunk << @logline
    assert !chunk.expired?
    Timecop.freeze(Time.now + 61) do
      assert chunk.expired?
      assert_raises(NFAgent::ChunkExpired) { chunk << @logline }
    end
  end

  test "day boundary" do
    d = Date.today
    Timecop.travel(Time.local(2011, 1, 10, 23, 59, 58)) do
      chunk = NFAgent::Chunk.new
      Timecop.travel(Time.local(2011, 1, 11, 0, 0, 10)) do
        assert_raises(NFAgent::DayBoundary) { chunk << @logline }
      end
    end
  end

  test "submit" do
    EM.expects(:defer)
    chunk = NFAgent::Chunk.new
    chunk.submit
  end

  test "dump" do
    Zlib::Deflate.expects(:deflate).returns("x\234\313\316*/\314HO-\312N\317(J\005\000&~\005u").times(2)
    chunk = NFAgent::Chunk.new
    chunk << @logline
    payload = chunk.dump
    assert_equal 1, payload.line_count
    assert_instance_of String, payload.data
    # Dump with key
    payload = chunk.dump('acme')
    assert_equal 'acme', payload.key
  end

  test "dump from LogLine" do
    pending
  end
end
