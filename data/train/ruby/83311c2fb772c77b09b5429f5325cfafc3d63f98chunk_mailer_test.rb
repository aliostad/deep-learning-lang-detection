require 'test_helper'

class ChunkMailerTest < ActionMailer::TestCase
  tests ChunkMailer
  def test_send_link
    @expected.subject = 'ChunkMailer#send_link'
    @expected.body    = read_fixture('send_link')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ChunkMailer.create_send_link(@expected.date).encoded
  end

  def test_notify_client
    @expected.subject = 'ChunkMailer#notify_client'
    @expected.body    = read_fixture('notify_client')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ChunkMailer.create_notify_client(@expected.date).encoded
  end

end
