require 'test/unit'
require 'subtitle_chunk'

class SubtitleChunkTest < Test::Unit::TestCase
  FIXTURE = <<-EOS
1
02:26:23,670 --> 02:26:26,138
"Multiline"
Subtitle Fixture.
  EOS

  def setup
    @chunk = SubtitleChunk.new FIXTURE

    hours = 2
    minutes = hours * 60 + 26
    seconds = minutes * 60 + 23.670
    @begin = seconds

    hours = 2
    minutes = hours * 60 + 26
    seconds = minutes * 60 + 26.138
    @end = seconds
  end


  def test_body_is_extracted
    assert_equal "\"Multiline\"\nSubtitle Fixture.", @chunk.body
  end

  def test_begin_time_is_extracted
    subtitle_begin = @chunk.begin
    assert subtitle_begin.is_a? Duration

    assert_equal @begin, subtitle_begin
  end

  def test_end_time_is_extracted
    subtitle_end = @chunk.end
    assert subtitle_end.is_a? Duration

    assert_equal @end, subtitle_end
  end

  def test_can_be_initialized_by_hash
    hash = {
        body: "TEST BODY",
        begin: 123,
        end: 456
    }
    subtitle = SubtitleChunk.new hash

    assert_equal hash[:body], subtitle.body
    assert_equal hash[:begin], subtitle.begin
    assert_equal hash[:end], subtitle.end
  end

  def test_can_be_shifted_in_place
    shift = 12.345
    @chunk.shift! shift

    assert_equal @begin + shift, @chunk.begin
    assert_equal @end + shift, @chunk.end
  end

  def test_can_be_shifted
    shift = 12.345
    subtitle = @chunk.shift shift

    assert_equal @begin + shift, subtitle.begin
    assert_equal @end + shift, subtitle.end
  end

  def test_can_be_shifted_by_plus
    shift = 12.345

    @chunk += shift

    assert_equal @begin + shift, @chunk.begin
    assert_equal @end + shift, @chunk.end
  end

  def test_can_be_shifted_by_minus
    shift = 12.345

    @chunk -= shift

    assert_equal @begin - shift, @chunk.begin
    assert_equal @end - shift, @chunk.end
  end

  def test_body_cannot_be_empty
    assert_raise EmptyBodyError do
      SubtitleChunk.new body: " \n",
                   begin: 1,
                   end: 2
    end
  end

  def test_chunk_must_have_order_number
    chunk = <<-EOS
02:26:23,670 --> 02:26:26,138
"Multiline"
Subtitle Fixture.
    EOS
    assert_raise ParseError do
      SubtitleChunk.new chunk
    end
  end

  def test_chunk_must_have_time
    chunk = <<-EOS
1
"Multiline"
SubtitleChunk Fixture.
    EOS
    assert_raise ParseError do
      SubtitleChunk.new chunk
    end
  end

  def test_chunk_must_have_body
    chunk = <<-EOS
1
02:26:23,670 --> 02:26:26,138
    EOS
    assert_raise ParseError do
      SubtitleChunk.new chunk
    end
  end

  def test_chunk_must_have_begin_time
    assert_raise NoTimeError do
      SubtitleChunk.new body: 'TEST',
                        begin: nil,
                        end: 1
    end
  end

  def test_end_time_must_be_greater_than_begin_time
    assert_raise OverlapError do
      SubtitleChunk.new body: 'TEST',
                            begin: 3,
                            end: 2
    end
  end

  def test_can_be_written_without_an_order
    fixture_without_first_line = FIXTURE.lines.drop(1).join
    assert_equal fixture_without_first_line, @chunk.to_s
  end

  def test_can_be_written_with_an_order
    assert_equal FIXTURE, @chunk.to_s(1)
  end

  def test_can_be_duplicated
    chunk = @chunk.dup

    assert_equal chunk.to_s, @chunk.to_s
    assert_not_same chunk, @chunk

    assert_equal chunk.begin.to_s, @chunk.begin.to_s
    assert_not_same chunk.begin, @chunk.begin

    assert_equal chunk.end.to_s, @chunk.end.to_s
    assert_not_same chunk.end, @chunk.end
  end

end