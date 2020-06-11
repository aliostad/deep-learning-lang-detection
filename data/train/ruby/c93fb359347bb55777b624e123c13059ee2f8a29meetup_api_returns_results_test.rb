require 'test_helper'

class MeetupApiReturnsResultsTest < ActionDispatch::IntegrationTest

  def request
    @meetup_interests = MeetupService.new('Camping, Hiking, Software Development, Dancing', 30606)
  end

  test 'should have proper input' do
    request

    assert_not @meetup_interests.nil?
  end

  test 'should have api key' do
    assert_not Rails.application.secrets.meetup_api.nil?
  end

  test 'should not allow invalid keys' do
    Rails.application.secrets.meetup_api = 'invalid'
    request
    assert @meetup_interests.execute.nil?
  end

  test 'should calculate total member score' do
    request
    assert_equal 100, @meetup_interests.calculate_total_member_score(1180)
    assert_equal 100, @meetup_interests.calculate_total_member_score(123)
    assert_equal 20, @meetup_interests.calculate_total_member_score(23)
    assert_equal 0, @meetup_interests.calculate_total_member_score(-10)
  end

  test 'should calculate total meetup score' do
    request
    assert_equal 0, @meetup_interests.calculate_total_meetup_score(0)
    assert_equal 25, @meetup_interests.calculate_total_meetup_score(3)
    assert_equal 50, @meetup_interests.calculate_total_meetup_score(5)
    assert_equal 75, @meetup_interests.calculate_total_meetup_score(7)
    assert_equal 100, @meetup_interests.calculate_total_meetup_score(17)
  end

  test 'should calculate final score' do
    request
    assert_equal 75.0, @meetup_interests.calculate_score(1180, 4)
    assert_equal 35.0, @meetup_interests.calculate_score(25, 4)
    assert_equal 62.5, @meetup_interests.calculate_score(55, 7)
  end

  test 'should return valid response array' do
    request
    response = @meetup_interests.execute
    #assert_equal(response[0][0]['name'], 'Camping')
  end

end
