require File.expand_path('../../test_helper', __FILE__)

class ProcessMemberTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :groups_users
  fixtures :trackers
  fixtures :issues
  
  def setup
    @user = User.find(2)
    assert @user.save
    @issue = Issue.first
    assert @issue.save
    @process_role = ProcessRole.new(:tracker => Tracker.first, :name => 'role_name')
    assert @process_role.save
  end
  
  def test_create
    member = ProcessMember.new(:process_role => @process_role, :principal => @user, :issue => @issue)
    assert member.save
    
    assert_equal @process_role, member.process_role
    assert_equal @user, member.principal
    assert_equal @issue, member.issue
  end
  
  def test_create_group
    group = Group.find(10)
    member = ProcessMember.new(:process_role => @process_role, :user_id => group.id, :issue => @issue)
    assert member.save
    
    assert_equal group, member.principal
  end
  
  def test_destroy_issue
    member = ProcessMember.new(:process_role => @process_role, :principal => @user, :issue => @issue)
    assert member.save
    
    issue_id = @issue.id
    @issue.destroy
    
    assert ProcessMember.where(:issue_id => issue_id).empty?
  end
  
  def test_change_issue_tracker
    member = ProcessMember.new(:process_role => @process_role, :principal => @user, :issue => @issue)
    assert member.save
    
    @issue.tracker = Tracker.last
    assert @issue.save
    assert ProcessMember.where(:issue_id => @issue.id).empty?
  end
  
  def test_destroy_user
    member = ProcessMember.new(:process_role => @process_role, :principal => @user, :issue => @issue)
    assert member.save
    
    id = @user.id
    @user.destroy
    
    assert ProcessMember.where(:user_id => id).empty?
  end
  
  def test_destroy_role
    member = ProcessMember.new(:process_role => @process_role, :principal => @user, :issue => @issue)
    assert member.save
    
    id = @process_role.id
    @process_role.destroy
    
    assert ProcessMember.where(:process_role_id => id).empty?
  end
  
  def test_create_without_process_role
    member = ProcessMember.new(:principal => @user, :issue => @issue)
    assert !member.save
  end
  
  def test_create_without_user
    member = ProcessMember.new(:process_role => @process_role, :issue => @issue)
    assert member.save
  end
  
  def test_create_without_issue
    member = ProcessMember.new(:process_role => @process_role, :principal => @user)
    assert !member.save
  end
end
