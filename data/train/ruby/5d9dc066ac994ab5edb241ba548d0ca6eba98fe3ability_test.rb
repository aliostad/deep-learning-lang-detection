require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  
  setup do
    @category = Category.new
    @assignment = Assignment.new
    @project = Project.new
    @public_scrap = FactoryGirl.build(:public_scrap)
    @registered_scrap = FactoryGirl.build(:registered_scrap)
    @private_scrap = FactoryGirl.build(:private_scrap)
    @scrap_image = Scrap::Image.new
    @comment = Comment.new
    @user = User.new
    @like = Like.new
    @flag = Flag.new
    @link = Link.new
    @notification = Notification.new
  end
  
  test "teacher can do anything" do
    teacher = create_teacher
    ability = Ability.new(teacher)
    assert ability.can?(:read, @category)
    assert ability.cannot?(:manage, @category)

    assert ability.can?(:manage, @assignment)
    assert ability.can?(:manage, @project)
    assert ability.can?(:manage, @public_scrap)
    assert ability.can?(:manage, @registered_scrap)
    assert ability.can?(:manage, @private_scrap)
    assert ability.can?(:manage, @scrap_image)
    assert ability.can?(:manage, @comment)
    assert ability.can?(:manage, @user)
    assert ability.can?(:manage, @flag)
    assert ability.can?(:manage, @link)

    assert ability.cannot?(:manage, @like)
    assert ability.can?(:manage, FactoryGirl.create(:like, :user => teacher))
    assert ability.cannot?(:manage, @notification)
    assert ability.can?(:manage, FactoryGirl.create(:notification, :user => teacher))
  end
  
  test "student can do anything" do
    student = create_student
    ability = Ability.new(student)
    
    assert ability.cannot?(:manage, @category)
    assert ability.cannot?(:manage, @assignment)
    assert ability.cannot?(:manage, @project)
    assert ability.cannot?(:manage, @public_scrap)
    assert ability.cannot?(:manage, @registered_scrap)
    assert ability.cannot?(:manage, @scrap_image)
    assert ability.cannot?(:manage, @comment)
    assert ability.cannot?(:manage, @user)
    assert ability.cannot?(:manage, @like)
    assert ability.cannot?(:read, @private_scrap)
    assert ability.cannot?(:manage, @flag)
    assert ability.cannot?(:manage, @link)
    assert ability.cannot?(:manage, @notification)
    
    assert ability.can?(:read, @category)
    assert ability.can?(:read, @assignment)
    assert ability.can?(:read, @project)
    assert ability.can?(:read, @public_scrap)
    assert ability.can?(:read, @registered_scrap)
    assert ability.can?(:read, @scrap_image)
    assert ability.can?(:read, @comment)
    assert ability.can?(:read, @user)
    assert ability.can?(:read, @flag)
    assert ability.can?(:read, @link)
    
    assert ability.can?(:manage, FactoryGirl.create(:project, :user => student))
    assert ability.can?(:manage, FactoryGirl.create(:scrap, :user => student))
    assert ability.can?(:manage, FactoryGirl.create(:scrap_image, :user => student))
    assert ability.can?(:manage, FactoryGirl.create(:comment, :user => student))
    assert ability.can?(:manage, FactoryGirl.create(:like, :user => student))
    assert ability.can?(:manage, FactoryGirl.create(:link, :user => student))
    assert ability.can?(:manage, FactoryGirl.create(:notification, :user => student))
    assert ability.can?(:manage, student)
  end
  
  test "guest can only read" do
    guest = User.new
    ability = Ability.new(guest)
    
    assert ability.cannot?(:manage, @category)
    assert ability.cannot?(:manage, @assignment)
    assert ability.cannot?(:manage, @project)
    assert ability.cannot?(:manage, @public_scrap)
    assert ability.cannot?(:manage, @scrap_image)
    assert ability.cannot?(:manage, @comment)
    assert ability.cannot?(:manage, @user)
    assert ability.cannot?(:manage, @like)
    assert ability.cannot?(:manage, @flag)
    assert ability.cannot?(:read, @registered_scrap)
    assert ability.cannot?(:read, @private_scrap)
    assert ability.cannot?(:manage, @link)
    assert ability.cannot?(:manage, @notification)
    
    assert ability.can?(:read, @category)
    assert ability.can?(:read, @assignment)
    assert ability.can?(:read, @project)
    assert ability.can?(:read, @public_scrap)
    assert ability.can?(:read, @scrap_image)
    assert ability.can?(:read, @comment)
    assert ability.can?(:read, @user)
    assert ability.can?(:read, @like)
    assert ability.can?(:create, @user)
    assert ability.can?(:read, @flag)
    assert ability.can?(:read, @link)
  end
  
end
