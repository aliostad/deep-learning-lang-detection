require 'rails_helper'

describe Ability, :type => :model do
  before :each do
    @user = create(:user)
    @ability = Ability.new(@user)
  end

  it "user should manage only own project" do
    expect(@ability).to be_able_to(:manage, create(:project, user: @user))
    expect(@ability).to_not be_able_to(:manage, create(:project))
  end

  it "user should manage task only own project" do
    project = create(:project, user: @user)
    expect(@ability).to be_able_to(:manage, create(:task, project: project))
    expect(@ability).to_not be_able_to(:manage, create(:task))
  end

  it "user should manage comment only own task" do
    project = create(:project, user: @user)
    task = create(:task, project: project)
    expect(@ability).to be_able_to(:manage, create(:comment, task: task))
    expect(@ability).to_not be_able_to(:manage, create(:comment))
  end

end







