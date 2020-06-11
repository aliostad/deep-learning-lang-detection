require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  setup do
    @user = Factory(:user, :username => 'bob', :password => 'secret')
    @course = Factory(:course)
    @repository = Factory(:repository, :user => @user)
  end
  teardown :clean_local_fs!

  test "should create assignment with attached course and repository" do
    assignment = Factory(:assignment, :course => @course, :repository => @repository)
    assert_equal(@course, assignment.course)
    assert_equal(@repository, assignment.repository)
    assert_equal(assignment, @repository.storeable)
  end
end
